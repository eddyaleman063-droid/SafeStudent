const express = require('express');
const admin = require('firebase-admin');
const crypto = require('crypto');
const { MercadoPagoConfig, Preference } = require('mercadopago');

// ── Firebase Admin ──────────────────────────────────────────────
if (admin.apps.length === 0) {
  const saKey = process.env.FIREBASE_SERVICE_ACCOUNT_KEY;
  if (saKey) {
    admin.initializeApp({ credential: admin.credential.cert(JSON.parse(saKey)) });
  } else {
    admin.initializeApp();
  }
}

const MERCADOPAGO_ACCESS_TOKEN = process.env.MERCADOPAGO_ACCESS_TOKEN;
if (!MERCADOPAGO_ACCESS_TOKEN) {
  console.warn('MERCADOPAGO_ACCESS_TOKEN not configured. Set in Vercel env vars.');
}

const mpClient = new MercadoPagoConfig({
  accessToken: MERCADOPAGO_ACCESS_TOKEN || '',
  options: { timeout: 15000 },
});

const APP_URL = 'sagen://';
const WEBHOOK_BASE = process.env.VERCEL_URL
  ? `https://${process.env.VERCEL_URL}`
  : 'https://sagen-app.vercel.app';

const STREAK_SHIELD_MAX = 2;

const productCatalog = {
  'gems_50':    { gems: 50,   title: '50 Gemas - SAGEN',            price: 5.00,  bonuses: [] },
  'gems_120':   { gems: 120,  title: '120 Gemas - SAGEN',           price: 10.00, bonuses: [] },
  'gems_300':   { gems: 300,  title: '300 Gemas - SAGEN',           price: 20.00, bonuses: [] },
  'gems_500':   { gems: 500,  title: '500 Gemas - SAGEN',           price: 35.00, bonuses: [] },
  'gems_1000':  { gems: 1000, title: '1000 Gemas - SAGEN',          price: 60.00, bonuses: [] },
  'bundle_protector':   { gems: 100,  title: 'Pack Protegido - SAGEN',      price: 12.00, bonuses: [{ type: 'streakProtector', quantity: 1 }] },
  'bundle_xp':          { gems: 200,  title: 'Pack Impulso - SAGEN',        price: 20.00, bonuses: [{ type: 'xpBoost', quantity: 1 }] },
  'bundle_multiplier':  { gems: 300,  title: 'Pack Fortuna - SAGEN',        price: 28.00, bonuses: [{ type: 'gemMultiplier', quantity: 1 }] },
  'bundle_luck':        { gems: 250,  title: 'Pack Suerte - SAGEN',         price: 24.00, bonuses: [{ type: 'luckBoost', quantity: 1 }] },
};

function getProductDetails(productId, gemsFromClient, priceFromClient, bonusesFromClient) {
  const catalog = productCatalog[productId];
  if (catalog) return catalog;
  return { gems: gemsFromClient, title: `${gemsFromClient} Gemas - SAGEN`, price: priceFromClient || 0, bonuses: bonusesFromClient || [] };
}

function getStreakShieldSlots(currentShields) {
  return Math.max(0, STREAK_SHIELD_MAX - currentShields);
}

function shortHash(s) {
  return crypto.createHash('sha256').update(s).digest('hex').slice(0, 12);
}

// ── Auth middleware ─────────────────────────────────────────────
async function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization || '';
  const idToken = authHeader.replace('Bearer ', '');
  if (!idToken) {
    return res.status(401).json({ error: 'unauthenticated', message: 'Debes iniciar sesión' });
  }
  try {
    const decoded = await admin.auth().verifyIdToken(idToken);
    req.user = decoded;
    next();
  } catch {
    return res.status(401).json({ error: 'unauthenticated', message: 'Token inválido' });
  }
}

async function requireAdmin(req, res, next) {
  await requireAuth(req, res, async () => {
    const adminDoc = await admin.firestore().doc(`admins/${req.user.uid}`).get();
    if (!adminDoc.exists) {
      return res.status(403).json({ error: 'permission-denied', message: 'No tienes permisos de administrador' });
    }
    next();
  });
}

// ── Express app ────────────────────────────────────────────────
const app = express();
app.use(express.json());

// ────────────────────────────────────────────────────────────────
// POST /api/createPaymentPreference
// ────────────────────────────────────────────────────────────────
app.post('/api/createPaymentPreference', async (req, res) => {
  try {
    const { gems, userId, productId, bonuses, price } = req.body;
    if (!gems || !userId) {
      return res.status(400).json({ error: 'invalid-argument', message: 'Se requieren gems y userId' });
    }

    const pkg = getProductDetails(productId || `gems_${gems}`, gems, price, bonuses);
    const effectivePrice = price || pkg.price;
    const obfuscatedRef = `${shortHash(userId)}|${gems}|${productId || ''}|${Date.now()}`;

    const preference = new Preference(mpClient);
    const result = await preference.create({
      body: {
        items: [{
          id: productId || `gems_${gems}`,
          title: pkg.title,
          description: `${gems} gemas para usar en SAGEN`,
          quantity: 1,
          unit_price: effectivePrice,
          currency_id: 'PEN',
        }],
        external_reference: obfuscatedRef,
        metadata: { userId, gems, productId: productId || '' },
        back_urls: {
          success: `${APP_URL}payment/success`,
          failure: `${APP_URL}payment/failure`,
          pending: `${APP_URL}payment/pending`,
        },
        auto_return: 'approved',
        notification_url: `${WEBHOOK_BASE}/api/handlePaymentWebhook`,
        payment_methods: { installments: 1, default_installments: 1 },
      },
    });

    console.log('Preference created', { preferenceId: result.id, obfuscatedRef, gems, productId: productId || 'none' });
    res.json({ result: { preferenceId: result.id, initPoint: result.init_point || result.sandbox_init_point, externalRef: obfuscatedRef } });
  } catch (error) {
    console.error('createPaymentPreference error', error);
    res.status(500).json({ error: 'internal', message: 'Error al crear la preferencia de pago' });
  }
});

// ────────────────────────────────────────────────────────────────
// POST /api/handlePaymentWebhook
// ────────────────────────────────────────────────────────────────
app.post('/api/handlePaymentWebhook', async (req, res) => {
  try {
    const { type, data } = req.body;
    console.log('Webhook received', { type, data });

    if (type !== 'payment' || !data?.id) {
      return res.status(200).send('OK');
    }

    const paymentId = data.id.toString();
    const response = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
      headers: { Authorization: `Bearer ${MERCADOPAGO_ACCESS_TOKEN}` },
    });

    if (!response.ok) {
      console.error('Failed to fetch payment', { paymentId, status: response.status });
      return res.status(200).send('OK');
    }

    const payment = await response.json();
    const externalRef = payment.external_reference || '';
    const extParts = externalRef.split('|');
    const userId = payment.metadata?.userId || extParts[0] || '';
    const gems = parseInt(payment.metadata?.gems || extParts[1], 10);
    const productId = payment.metadata?.productId || extParts[2] || null;

    if (payment.status !== 'approved') {
      if (payment.status === 'pending' || payment.status === 'in_process') {
        const pendingRef = admin.firestore().collection('pending_payments').doc(paymentId);
        const pendingDoc = await pendingRef.get();
        if (!pendingDoc.exists) {
          await pendingRef.set({
            userId, paymentMethod: 'mercadopago', operationId: paymentId,
            amount: payment.transaction_amount || 0, productId, status: payment.status, externalRef,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            expiresAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 48 * 60 * 60 * 1000)),
          });
        }
      }
      return res.status(200).send('OK');
    }

    if (!userId || isNaN(gems) || gems <= 0) {
      console.error('Invalid userId or gems', { userId, gems });
      return res.status(200).send('OK');
    }

    const userRef = admin.firestore().doc(`users/${userId}`);
    const logRef = admin.firestore().doc(`payment_logs/${paymentId}`);
    const pkg = productCatalog[productId];
    const bonuses = pkg ? pkg.bonuses : [];

    await admin.firestore().runTransaction(async (transaction) => {
      const [userDoc, logDoc] = await Promise.all([transaction.get(userRef), transaction.get(logRef)]);
      if (logDoc.exists) return;

      if (!userDoc.exists) {
        console.error('User not found', { userId });
        return;
      }

      const userData = userDoc.data() || {};
      const updateData = {
        learning_gems: (userData.learning_gems || 0) + gems,
        learning_total_gems: (userData.learning_total_gems || 0) + gems,
        lastPaymentAt: admin.firestore.FieldValue.serverTimestamp(),
        lastPaymentMethod: 'mercadopago',
        lastPaymentAmount: gems,
      };

      for (const bonus of bonuses) {
        if (bonus.type === 'streakProtector') {
          const currentShields = userData.shop_streak_shields || 0;
          const available = getStreakShieldSlots(currentShields);
          const toAdd = Math.min(bonus.quantity, available);
          if (toAdd > 0) updateData.shop_streak_shields = currentShields + toAdd;
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
        userId, gems, productId, bonuses, amount: payment.transaction_amount || 0,
        currency: payment.currency_id || 'PEN', paymentId, paymentMethod: payment.payment_method_id || 'unknown',
        status: payment.status, externalRef, createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    console.log('Payment processed', { userId, gems, productId: productId || 'none' });
    return res.status(200).send('OK');
  } catch (error) {
    console.error('Webhook handler error', error);
    return res.status(200).send('OK');
  }
});

// ────────────────────────────────────────────────────────────────
// POST /api/adminCreditGems
// ────────────────────────────────────────────────────────────────
app.post('/api/adminCreditGems', requireAdmin, async (req, res) => {
  try {
    const { userId, gems, paymentMethod, productId, idempotencyKey } = req.body;
    if (!userId || !gems || gems <= 0 || !idempotencyKey) {
      return res.status(400).json({ error: 'invalid-argument', message: 'userId, gems e idempotencyKey requeridos' });
    }

    const logRef = admin.firestore().doc(`payment_logs/${idempotencyKey}`);
    const userRef = admin.firestore().doc(`users/${userId}`);
    const method = paymentMethod || 'whatsapp';

    const result = await admin.firestore().runTransaction(async (transaction) => {
      const [logDoc, userDoc] = await Promise.all([transaction.get(logRef), transaction.get(userRef)]);
      if (logDoc.exists) {
        const existingData = logDoc.data() || {};
        return { success: true, duplicate: true, newBalance: existingData.postBalance || 0, bonuses: existingData.bonuses || [] };
      }
      if (!userDoc.exists) {
        throw new Error('Usuario no encontrado');
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
          if (toAdd > 0) updateData.shop_streak_shields = currentShields + toAdd;
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
        userId, gems, productId: productId || null, bonuses, method: 'manual_' + method,
        creditedBy: 'admin', postBalance: currentBalance + gems,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return { success: true, duplicate: false, newBalance: currentBalance + gems, bonuses };
    });

    console.log('Manual gems credited', { userId, gems, method });
    res.json({ result });
  } catch (error) {
    console.error('adminCreditGems error', error);
    if (error.message === 'Usuario no encontrado') {
      return res.status(404).json({ error: 'not-found', message: error.message });
    }
    res.status(500).json({ error: 'internal', message: 'Error al acreditar gemas' });
  }
});

// ────────────────────────────────────────────────────────────────
// POST /api/validatePurchase
// ────────────────────────────────────────────────────────────────
app.post('/api/validatePurchase', async (req, res) => {
  try {
    const { cost, itemId, userId } = req.body;
    if (!cost || cost <= 0 || !itemId || !userId) {
      return res.status(400).json({ error: 'invalid-argument', message: 'cost, itemId y userId requeridos' });
    }
    const userRef = admin.firestore().doc(`users/${userId}`);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      return res.status(404).json({ error: 'not-found', message: 'Usuario no encontrado' });
    }

    const balance = userDoc.data()?.learning_gems || 0;
    if (balance < cost) {
      return res.status(400).json({ error: 'failed-precondition', message: 'Gemas insuficientes' });
    }

    const payload = JSON.stringify({ userId, itemId, cost, ts: Date.now(), exp: Date.now() + 60000 });
    const hmac = crypto.createHmac('sha256', 'fallback-dev-secret').update(payload).digest('hex');
    const token = Buffer.from(JSON.stringify({ payload, sig: hmac })).toString('base64');

    console.log('Purchase validation token issued', { userId, itemId, cost });
    res.json({ result: { valid: true, balance, token } });
  } catch (error) {
    console.error('validatePurchase error', error);
    res.status(500).json({ error: 'internal', message: 'Error al validar la compra' });
  }
});

// ────────────────────────────────────────────────────────────────
// POST /api/registerPendingPayment
// ────────────────────────────────────────────────────────────────
app.post('/api/registerPendingPayment', async (req, res) => {
  try {
    const { paymentMethod, operationId, amount, productId } = req.body;
    if (!paymentMethod || !operationId) {
      return res.status(400).json({ error: 'invalid-argument', message: 'paymentMethod y operationId requeridos' });
    }

    const validMethods = ['whatsapp', 'yape', 'plin'];
    if (!validMethods.includes(paymentMethod)) {
      return res.status(400).json({ error: 'invalid-argument', message: 'Método de pago no válido' });
    }

    const userId = req.user.uid;
    const pendingRef = admin.firestore().collection('pending_payments').doc();
    await pendingRef.set({
      userId, paymentMethod, operationId, amount: amount || 0, productId: productId || null,
      status: 'pending', createdAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 24 * 60 * 60 * 1000)),
    });

    console.log('Pending payment registered', { userId, paymentMethod, operationId, pendingId: pendingRef.id });
    res.json({ result: { success: true, pendingPaymentId: pendingRef.id } });
  } catch (error) {
    console.error('registerPendingPayment error', error);
    res.status(500).json({ error: 'internal', message: 'Error al registrar el pago' });
  }
});

// ────────────────────────────────────────────────────────────────
// GET /api/health
// ────────────────────────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', project: 'sagen-vercel', mercadopagoConfigured: !!MERCADOPAGO_ACCESS_TOKEN });
});

// ── Export for Vercel ───────────────────────────────────────────
module.exports = app;
