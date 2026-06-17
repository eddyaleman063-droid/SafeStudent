const functions = require('firebase-functions');
const admin = require('firebase-admin');
const crypto = require('crypto');
const { MercadoPagoConfig, Preference } = require('mercadopago');

admin.initializeApp();

const MERCADOPAGO_ACCESS_TOKEN = functions.config().mercadopago?.access_token;
if (!MERCADOPAGO_ACCESS_TOKEN) {
  console.warn('MERCADOPAGO_ACCESS_TOKEN not configured. Set via: firebase functions:config:set mercadopago.access_token="APP_USR-xxx"');
}

const mpClient = new MercadoPagoConfig({
  accessToken: MERCADOPAGO_ACCESS_TOKEN || '',
  options: { timeout: 15000 },
});

const APP_URL = 'sagen://';
const WEBHOOK_BASE = `https://${process.env.GCLOUD_PROJECT ? process.env.GCLOUD_PROJECT + '.web.app' : 'us-central1-' + (process.env.GCLOUD_PROJECT || 'sagen-bdd3f') + '.cloudfunctions.net'}`;

const STREAK_SHIELD_MAX = 2;

const productCatalog = {
  'gems_50':        { gems: 50,   title: '50 Gemas - SAGEN',            price: 5.00,  bonuses: [] },
  'gems_120':       { gems: 120,  title: '120 Gemas - SAGEN',           price: 10.00, bonuses: [] },
  'gems_300':       { gems: 300,  title: '300 Gemas - SAGEN',           price: 20.00, bonuses: [] },
  'gems_500':       { gems: 500,  title: '500 Gemas - SAGEN',           price: 35.00, bonuses: [] },
  'gems_1000':      { gems: 1000, title: '1000 Gemas - SAGEN',          price: 60.00, bonuses: [] },
  'bundle_protector':   { gems: 100,  title: 'Pack Protegido - SAGEN',      price: 12.00, bonuses: [{ type: 'streakProtector', quantity: 1 }] },
  'bundle_xp':          { gems: 200,  title: 'Pack Impulso - SAGEN',        price: 20.00, bonuses: [{ type: 'xpBoost', quantity: 1 }] },
  'bundle_multiplier':  { gems: 300,  title: 'Pack Fortuna - SAGEN',        price: 28.00, bonuses: [{ type: 'gemMultiplier', quantity: 1 }] },
  'bundle_luck':        { gems: 250,  title: 'Pack Suerte - SAGEN',         price: 24.00, bonuses: [{ type: 'luckBoost', quantity: 1 }] },
};

function getProductDetails(productId, gemsFromClient, priceFromClient, bonusesFromClient) {
  const catalog = productCatalog[productId];
  if (catalog) return catalog;

  return {
    gems: gemsFromClient,
    title: `${gemsFromClient} Gemas - SAGEN`,
    price: priceFromClient || 0,
    bonuses: bonusesFromClient || [],
  };
}

function getProductBonuses(gems) {
  const match = Object.values(productCatalog).find(p => p.gems === gems && p.bonuses.length === 0);
  if (match) return match;
  return { bonuses: [] };
}

function getStreakShieldSlots(currentShields) {
  return Math.max(0, STREAK_SHIELD_MAX - currentShields);
}

/**
 * HTTPS Callable: Creates a Mercado Pago checkout preference
 */
exports.createPaymentPreference = functions.https.onCall(async (data, context) => {
  const { gems, userId, productId, bonuses, price } = data;

  if (!gems || !userId) {
    throw new functions.https.HttpsError(
      'invalid-argument', 'Se requieren gems y userId'
    );
  }

  const pkg = getProductDetails(productId || `gems_${gems}`, gems, price, bonuses);
  const effectivePrice = price || pkg.price;

  const shortHash = (s) => crypto.createHash('sha256').update(s).digest('hex').slice(0, 12);
  const obfuscatedRef = `${shortHash(userId)}|${gems}|${productId || ''}|${Date.now()}`;

  const preferenceData = {
    body: {
      items: [
        {
          id: productId || `gems_${gems}`,
          title: pkg.title,
          description: `${gems} gemas para usar en SAGEN`,
          quantity: 1,
          unit_price: effectivePrice,
          currency_id: 'PEN',
        },
      ],
      external_reference: obfuscatedRef,
      metadata: {
        userId,
        gems,
        productId: productId || '',
      },
      back_urls: {
        success: `${APP_URL}payment/success`,
        failure: `${APP_URL}payment/failure`,
        pending: `${APP_URL}payment/pending`,
      },
      auto_return: 'approved',
      notification_url: `${WEBHOOK_BASE}/handlePaymentWebhook`,
      payment_methods: {
        installments: 1,
        default_installments: 1,
      },
    },
  };

  try {
    const preference = new Preference(mpClient);
    const result = await preference.create(preferenceData);

    functions.logger.info('Preference created', {
      preferenceId: result.id,
      obfuscatedRef,
      gems,
      productId: productId || 'none',
    });

    return {
      preferenceId: result.id,
      initPoint: result.init_point || result.sandbox_init_point,
      externalRef: obfuscatedRef,
    };
  } catch (error) {
    functions.logger.error('Failed to create preference', error);
    throw new functions.https.HttpsError(
      'internal',
      'Error al crear la preferencia de pago. Intenta de nuevo.',
    );
  }
});

/**
 * HTTP endpoint: Receives Mercado Pago payment notifications (webhook)
 *
 * Idempotency design:
 *   ▸ Fetch payment from MP API before the transaction.
 *   ▸ Inside a Firestore transaction, read payment_logs/{paymentId}
 *     AND users/{userId} atomically.
 *   ▸ If the log doc already exists → return early (no writes = no-op).
 *   ▸ Only then update the user doc and create the log doc.
 *   ▸ `transaction.create()` doubles as a safety net — if by some
 *     race a concurrent txn got there first, create throws, aborting
 *     the whole transaction. No double credit possible.
 */
exports.handlePaymentWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const { type, data } = req.body;

    functions.logger.info('Webhook received', { type, data });

    if (type !== 'payment' || !data?.id) {
      return res.status(200).send('OK');
    }

    const paymentId = data.id.toString();

    // ── FETCH PAYMENT FROM MP API ─────────────────────────────
    const response = await fetch(
      `https://api.mercadopago.com/v1/payments/${paymentId}`,
      {
        headers: {
          Authorization: `Bearer ${MERCADOPAGO_ACCESS_TOKEN}`,
        },
      }
    );

    if (!response.ok) {
      functions.logger.error('Failed to fetch payment', {
        paymentId,
        status: response.status,
      });
      return res.status(200).send('OK');
    }

    const payment = await response.json();

    const externalRef = payment.external_reference || '';
    // Extract userId from metadata (preferred) or fallback to externalRef parsing
    const extParts = externalRef.split('|');
    const userId = payment.metadata?.userId || extParts[0] || '';
    const gems = parseInt(
      payment.metadata?.gems || extParts[1],
      10,
    );
    const productId = payment.metadata?.productId || extParts[2] || null;

    if (payment.status !== 'approved') {
      // Si está pending, registrar en pending_payments para seguimiento
      if (payment.status === 'pending' || payment.status === 'in_process') {
        const pendingRef = admin.firestore().collection('pending_payments').doc(paymentId);
        const pendingDoc = await pendingRef.get();
        if (!pendingDoc.exists) {
          await pendingRef.set({
            userId,
            paymentMethod: 'mercadopago',
            operationId: paymentId,
            amount: payment.transaction_amount || 0,
            productId: productId,
            status: payment.status,
            externalRef,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            expiresAt: admin.firestore.Timestamp.fromDate(
              new Date(Date.now() + 48 * 60 * 60 * 1000),
            ),
          });
          functions.logger.info('Pending payment registered from webhook', { paymentId, userId });
        }
      }
      functions.logger.info('Payment not approved', {
        paymentId,
        status: payment.status,
      });
      return res.status(200).send('OK');
    }

    if (!userId || isNaN(gems) || gems <= 0) {
      functions.logger.error('Invalid userId or gems', { userId, gems });
      return res.status(200).send('OK');
    }

    const userRef = admin.firestore().doc(`users/${userId}`);
    const logRef = admin.firestore().doc(`payment_logs/${paymentId}`);
    const pkg = productCatalog[productId];
    const bonuses = pkg ? pkg.bonuses : [];

    // ── ATOMIC TRANSACTION with idempotency INSIDE ────────────
    // Read user + log in the same transaction so no two concurrent
    // webhooks can both pass the idempotency gate.
    await admin.firestore().runTransaction(async (transaction) => {
      const [userDoc, logDoc] = await Promise.all([
        transaction.get(userRef),
        transaction.get(logRef),
      ]);

      // If log already exists, payment was already processed
      if (logDoc.exists) {
        functions.logger.info('Payment already processed (transaction idempotent)', { paymentId });
        return; // no writes = no-op commit
      }

      if (!userDoc.exists) {
        functions.logger.error('User not found in transaction', { userId });
        return;
      }

      const userData = userDoc.data() || {};
      const currentBalance = userData.learning_gems || 0;
      const currentTotalEarned = userData.learning_total_gems || 0;

      const updateData = {
        learning_gems: currentBalance + gems,
        learning_total_gems: currentTotalEarned + gems,
        lastPaymentAt: admin.firestore.FieldValue.serverTimestamp(),
        lastPaymentMethod: 'mercadopago',
        lastPaymentAmount: gems,
      };

      for (const bonus of bonuses) {
        if (bonus.type === 'streakProtector') {
          const currentShields = userData.shop_streak_shields || 0;
          const available = getStreakShieldSlots(currentShields);
          const toAdd = Math.min(bonus.quantity, available);
          if (toAdd > 0) {
            updateData.shop_streak_shields = currentShields + toAdd;
            functions.logger.info('Credited streak shields', {
              userId, previous: currentShields, added: toAdd, newTotal: currentShields + toAdd,
            });
          } else {
            functions.logger.warn('Streak shield cap reached, not crediting', {
              userId, currentShields, max: STREAK_SHIELD_MAX,
            });
          }
        } else if (bonus.type === 'xpBoost') {
          updateData.shop_purchased_xp_boosts = (userData.shop_purchased_xp_boosts || 0) + bonus.quantity;
        } else if (bonus.type === 'gemMultiplier') {
          updateData.shop_purchased_gem_multipliers = (userData.shop_purchased_gem_multipliers || 0) + bonus.quantity;
        } else if (bonus.type === 'luckBoost') {
          updateData.shop_purchased_luck_boosts = (userData.shop_purchased_luck_boosts || 0) + bonus.quantity;
        }
      }

      transaction.update(userRef, updateData);

      // Create log with paymentId as doc ID — `transaction.create`
      // throws if the doc already exists, aborting this transaction
      // so no double-spending is possible.
      transaction.create(logRef, {
        userId,
        gems,
        productId: productId || null,
        bonuses: bonuses,
        amount: payment.transaction_amount || 0,
        currency: payment.currency_id || 'PEN',
        paymentId,
        paymentMethod: payment.payment_method_id || 'unknown',
        status: payment.status,
        externalRef,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    functions.logger.info('Payment processed atomically', {
      userId, gems, productId: productId || 'none', bonuses: bonuses.length,
    });

    return res.status(200).send('OK');
  } catch (error) {
    functions.logger.error('Webhook handler error', error);
    return res.status(200).send('OK');
  }
});

/**
 * HTTP endpoint: Admin manual gem crediting for WhatsApp/Yape/Plin payments
 *
 * Idempotency design:
 *   ▸ The client generates a unique `idempotencyKey` (e.g. SHA-256 of
 *     `userId|gems|productId|timestamp`) and sends it with the request.
 *   ▸ Inside a Firestore transaction, read payment_logs/{idempotencyKey} and
 *     users/{userId} atomically.
 *   ▸ If the log doc already exists → return the previous result (no-op).
 *   ▸ Only then update the user doc and create the log doc.
 *   ▸ `transaction.create()` on the log doc prevents any race-condition
 *     double-credit even if called concurrently with the same key.
 */
exports.adminCreditGems = functions.https.onCall(async (data, context) => {
  const { userId, gems, paymentMethod, productId, idempotencyKey } = data;

  // Uso context.auth en vez de adminSecret
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated', 'Debes iniciar sesión para usar esta función'
    );
  }
  const callerUid = context.auth.uid;

  // Solo admins pueden llamar esta función
  const adminDoc = await admin.firestore().doc(`admins/${callerUid}`).get();
  if (!adminDoc.exists) {
    throw new functions.https.HttpsError(
      'permission-denied', 'No tienes permisos de administrador'
    );
  }

  if (!userId || !gems || gems <= 0) {
    throw new functions.https.HttpsError(
      'invalid-argument', 'userId y gems requeridos'
    );
  }

  if (!idempotencyKey) {
    throw new functions.https.HttpsError(
      'invalid-argument', 'idempotencyKey requerido'
    );
  }

  const logRef = admin.firestore().doc(`payment_logs/${idempotencyKey}`);
  const userRef = admin.firestore().doc(`users/${userId}`);
  const method = paymentMethod || 'whatsapp';

  // ── ATOMIC TRANSACTION with idempotency ─────────────────────
  try {
    const result = await admin.firestore().runTransaction(async (transaction) => {
      const [logDoc, userDoc] = await Promise.all([
        transaction.get(logRef),
        transaction.get(userRef),
      ]);

      // If log already exists, this request was already processed
      if (logDoc.exists) {
        functions.logger.info('Admin credit already processed (idempotent)', { idempotencyKey, userId });
        const existingData = logDoc.data() || {};
        return {
          success: true,
          duplicate: true,
          newBalance: existingData.postBalance || 0,
          bonuses: existingData.bonuses || [],
        };
      }

      if (!userDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Usuario no encontrado');
      }

      const userData = userDoc.data() || {};
      const currentBalance = userData.learning_gems || 0;
      const currentTotalEarned = userData.learning_total_gems || 0;

      const updateData = {
        learning_gems: currentBalance + gems,
        learning_total_gems: currentTotalEarned + gems,
        lastManualCreditAt: admin.firestore.FieldValue.serverTimestamp(),
        lastManualCreditMethod: method,
        lastManualCreditAmount: gems,
      };

      const pkg = productCatalog[productId];
      const bonuses = pkg ? pkg.bonuses : [];

      for (const bonus of bonuses) {
        if (bonus.type === 'streakProtector') {
          const currentShields = userData.shop_streak_shields || 0;
          const available = getStreakShieldSlots(currentShields);
          const toAdd = Math.min(bonus.quantity, available);
          if (toAdd > 0) {
            updateData.shop_streak_shields = currentShields + toAdd;
          }
        } else if (bonus.type === 'xpBoost') {
          updateData.shop_purchased_xp_boosts = (userData.shop_purchased_xp_boosts || 0) + bonus.quantity;
        } else if (bonus.type === 'gemMultiplier') {
          updateData.shop_purchased_gem_multipliers = (userData.shop_purchased_gem_multipliers || 0) + bonus.quantity;
        } else if (bonus.type === 'luckBoost') {
          updateData.shop_purchased_luck_boosts = (userData.shop_purchased_luck_boosts || 0) + bonus.quantity;
        }
      }

      transaction.update(userRef, updateData);
      transaction.create(logRef, {
        userId,
        gems,
        productId: productId || null,
        bonuses: bonuses,
        method: 'manual_' + method,
        creditedBy: 'admin',
        postBalance: currentBalance + gems,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      let resultBonuses = bonuses.map(b => ({ ...b }));
      if (productId === 'bundle_protector') {
        const newShields = (userData.shop_streak_shields || 0) +
          Math.min(bonuses.find(b => b.type === 'streakProtector')?.quantity || 0,
            getStreakShieldSlots(userData.shop_streak_shields || 0));
        resultBonuses = resultBonuses.map(b =>
          b.type === 'streakProtector'
            ? { ...b, quantity: newShields - (userData.shop_streak_shields || 0) }
            : b
        );
      }

      return {
        success: true,
        duplicate: false,
        newBalance: currentBalance + gems,
        bonuses: resultBonuses,
      };
    });

    functions.logger.info('Manual gems credited', { userId, gems, method, productId, duplicate: result.duplicate });

    return result;
  } catch (error) {
    functions.logger.error('Manual credit error', error);
    throw new functions.https.HttpsError('internal', 'Error al acreditar gemas');
  }
});

/**
 * HTTPS Callable: Server-side gem balance validation before purchase.
 * Returns a signed token that the client must include in the spend request.
 * The token expires after 60 seconds.
 */
exports.validatePurchase = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Debes iniciar sesión');
  }

  const { cost, itemId } = data;
  if (!cost || cost <= 0 || !itemId) {
    throw new functions.https.HttpsError('invalid-argument', 'cost e itemId requeridos');
  }

  const userId = context.auth.uid;
  const userRef = admin.firestore().doc(`users/${userId}`);

  try {
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Usuario no encontrado');
    }

    const userData = userDoc.data() || {};
    const balance = userData.learning_gems || 0;

    if (balance < cost) {
      throw new functions.https.HttpsError(
        'failed-precondition', 'Gemas insuficientes',
      );
    }

    // Generar token firmado que expira en 60 segundos
    const payload = JSON.stringify({
      userId,
      itemId,
      cost,
      ts: Date.now(),
      exp: Date.now() + 60000,
    });
    const secret = functions.config().mercadopago?.admin_secret || 'fallback-dev-secret';
    const hmac = crypto.createHmac('sha256', secret).update(payload).digest('hex');
    const token = Buffer.from(JSON.stringify({ payload, sig: hmac })).toString('base64');

    functions.logger.info('Purchase validation token issued', { userId, itemId, cost });

    return { valid: true, balance, token };
  } catch (error) {
    if (error instanceof functions.https.HttpsError) throw error;
    functions.logger.error('validatePurchase error', error);
    throw new functions.https.HttpsError('internal', 'Error al validar la compra');
  }
});

/**
 * HTTPS Callable: Register a pending payment (WhatsApp/Yape/Plin).
 * Saves to pending_payments collection for admin review.
 */
exports.registerPendingPayment = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Debes iniciar sesión');
  }

  const { paymentMethod, operationId, amount, productId } = data;
  if (!paymentMethod || !operationId) {
    throw new functions.https.HttpsError('invalid-argument', 'paymentMethod y operationId requeridos');
  }

  const validMethods = ['whatsapp', 'yape', 'plin'];
  if (!validMethods.includes(paymentMethod)) {
    throw new functions.https.HttpsError('invalid-argument', 'Método de pago no válido');
  }

  const userId = context.auth.uid;

  const pendingRef = admin.firestore().collection('pending_payments').doc();
  await pendingRef.set({
    userId,
    paymentMethod,
    operationId,
    amount: amount || 0,
    productId: productId || null,
    status: 'pending',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt: admin.firestore.Timestamp.fromDate(
      new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 horas
    ),
  });

  functions.logger.info('Pending payment registered', {
    userId, paymentMethod, operationId, pendingId: pendingRef.id,
  });

  return { success: true, pendingPaymentId: pendingRef.id };
});

/**
 * Health check endpoint
 */
exports.health = functions.https.onRequest(async (req, res) => {
  res.json({
    status: 'ok',
    project: process.env.GCLOUD_PROJECT || 'unknown',
    mercadopagoConfigured: !!MERCADOPAGO_ACCESS_TOKEN,
  });
});
