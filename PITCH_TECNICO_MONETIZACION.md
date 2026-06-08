# Pitch Técnico — Sistema de Monetización Híbrido + Gamificación
## SAGEN — Sprint 11/10 | Code Freeze

---

## 1. Economía de Gemas — Balance Exacto

### Ingreso diario gratuito (sin pagar)
| Fuente | Gemas/día | Condición |
|---|---|---|
| Cofre diario | **2** | Tocar el cofre una vez al día |
| Misiones (×3) | **1 c/u → 3** | Completar 3 misiones diarias |
| Anuncio recompensado | **1** | Ver 1 rewarded ad (se puede repetir) |
| **Total gratis/día** | **5 gemas** | Sin pagar ni un sol |

### Gasto por funcionalidad
| Acción | Costo |
|---|---|
| Análisis IA (Sage AI) | **3 gemas** |
| Cada análisis consume exactamente 3 gemas | |

### Relación oferta-demanda
- **5 gemas gratis/día** permiten **1 análisis gratis** y sobran 2 gemas
- Para **2 análisis/día**: faltan 4 gemas → ver **4 anuncios** o comprar paquete
- Para **3+ análisis/día**: compra obligatoria o uso intensivo de anuncios

### Paquetes de compra
| Paquete | Gemas | Precio S/ | Costo por gema |
|---|---|---|---|
| Básico | 50 | 5.00 | S/0.10 |
| Popular | 120 | 10.00 | S/0.083 |
| Premium | 300 | 20.00 | S/0.067 |

---

## 2. AdMob Rewarded Ads — Funcionamiento Técnico

### Arquitectura
- **SDK**: `google_mobile_ads` v5.2.0
- **Formato**: `RewardedAd` con callback API
- **Singleton**: `AdManagerService` — instancia única, carga un anuncio tras otro
- **Test ad unit**: `ca-app-pub-3940256099942544/5224354917` (Google test)
- **Precarga**: `_schedulePreload()` al completar un anuncio, mantiene cola llena

### Ciclo de vida
1. `load()` → `RewardedAd.loadWithAdUnitId()`
2. Usuario toca "Ver anuncio" → `show()`
3. Usuario ve 30s de video (no skippeable)
4. Callback `onAdRewarded(RewardedItem)` → adjudica **1 gema**
5. `_schedulePreload()` → carga el siguiente anuncio inmediatamente
6. Si falla → timeout 60s → reintento

### Modelo de negocio
- **CPM rural Perú**: ~$0.50–$1.50 USD por cada 1,000 impresiones
- Cada usuario que ve 4 anuncios/día genera ~$0.002–$0.006 USD/día
- A 1,000 DAU activos → $2–$6 USD/día solo en anuncios
- El rewarded ad permite al usuario "pagar con atención" en lugar de dinero real
- **Valor estratégico**: baja la barrera de entrada en zonas sin tarjeta de crédito

---

## 3. Flujo de Compra Cero-Comisiones (WhatsApp P2P)

### Por qué no Stripe/Visa
| Pasarela | Comisión | Configuración | Llegada del dinero |
|---|---|---|---|
| Stripe | 3.5% + $0.30 | Semanas, requiere RFC | 7 días |
| MercadoPago | 4.5% + $0.60 | Días, requiere cuenta | 14 días |
| **WhatsApp + Yape/Plin** | **0%** | **0 minutos, 0 servidores** | **Instantáneo** |

### Flujo técnico (`PaywallBottomSheet`)

```
Usuario elige paquete
  → _processLocalPayment()
    → Uri.https('wa.me', '/51934890627', {'text': mensaje})
    → canLaunchUrl() → launchUrl(externalApplication)
    → Se abre WhatsApp con mensaje predefinido:
      "Hola, quiero comprar el paquete de X gemas por S/XX.XX en SAGEN.
       Mi ID es: user_xxxxx"
    → Usuario envía → Desarrollador recibe notificación WhatsApp
    → Desarrollador verifica pago (Yape/Plin/MercadoPago)
    → Acredita gemas manualmente
```

### Seguridad
- `url_launcher` con `canLaunchUrl()` → si WhatsApp no está instalado, falla elegantemente
- Fallback: muestra `SnackBar` con enlace a MercadoPago (`mpago.li/XXXXXXXXX`)
- Sin almacenamiento de tarjetas, sin backend, sin PCI compliance
- Arquitectura preparada para migrar a Stripe SDK en <2h cuando se alcancen 10,000 usuarios

---

## 4. Mecánicas de Retención

### Cofre diario + Anti-cheat por fecha futura
- `GamificationRepository` en `lib/repositories/gamification_repository.dart`
- **Midnight reset UTC**: al abrir la app, compara `_lastChestDate` contra `DateTime.now().toUtc()`
- Si la fecha guardada en SharedPreferences es **anterior a hoy** → cofre disponible
- Si la fecha guardada es **posterior a hoy** → bloquea con `PlatformException("future_date")`
- No requiere NTP externo; la hora local es suficiente para detectar manipulación de reloj
- **No acumulación**: si no reclamas un día, pierdes las gemas de ese día

### Misiones diarias (3)
- Se refrescan automáticamente al cruzar la medianoche UTC
- Cada una otorga **1 gema**
- No se acumulan entre días
- Tipos: "Completa 1 análisis", "Gana 1 desafío", "Mantén racha de 3 días"

### Notificación push local a las 20:00
- Implementada con `flutter_local_notifications` v18 + `timezone`
- `zonedSchedule()` con `matchDateTimeComponents: DateTimeComponents.time`
- Se dispara **todos los días a las 20:00 hora local** (respeta zona horaria del dispositivo)
- Mensaje: *"¡Tu cofre diario te espera! No olvides reclamar tus gemas gratis en SAGEN."*
- No requiere Firebase Cloud Messaging ni backend
- Canal Android: `chest_reminder`, prioridad default

---

## 5. Stack Técnico del Módulo

| Componente | Tecnología | Archivo clave |
|---|---|---|
| Estado global | Riverpod (`ChangeNotifierProvider`) | `lib/providers/providers.dart` |
| Lógica de gamificación | Repositorio con SharedPreferences | `lib/repositories/gamification_repository.dart` |
| Provider Riverpod | `gamificationProvider` | `lib/providers/gamification_provider.dart` |
| Anuncios | `google_mobile_ads` 5.x RewardedAd | `lib/services/ad_manager_service.dart` |
| Paywall | `url_launcher` + WhatsApp deeplink | `lib/ui/widgets/paywall_bottom_sheet.dart` |
| Notificación 20:00 | `flutter_local_notifications` + `timezone` | `lib/services/notification_service.dart` |
| UI del cofre | Lottie + HapticFeedback + 1.5s delay | `lib/ui/widgets/chest_reward_dialog.dart` |
| Persistencia | SharedPreferences (offline-first) | — |

---

## 6. Drivers de Decisión Técnica

1. **"¿Por qué WhatsApp y no Stripe?"** — CAC cero: la pasarela formal cobra 3.5%+ por transacción. En un MVP con 100–200 usuarios en Perú, donde Yape/Plin son omnipresentes, WhatsApp P2P elimina costos fijos de servidor, comisiones bancarias y fricción de registro. Cuando la base de usuarios lo justifique, se intercambia el botón de WhatsApp por un SDK de Stripe en dos horas de desarrollo.

2. **"¿Es seguro?"** — No se almacenan datos bancarios, no hay backend que hackear, no hay PCI compliance. El flujo es idéntico a "transferencia bancaria manual" — el usuario paga, el desarrollador verifica y acredita. Es el mismo modelo de Negocios por WhatsApp que usan miles de emprendedores en Perú.

3. **"¿Por qué 3 gemas por análisis?"** — Calibrado para que el **usuario gratuito pueda hacer al menos 1 análisis/día sin pagar** (5 gemas gratis - 3 del análisis = sobran 2). El costo por análisis fuerza decisiones de uso consciente y evita abuso del recurso de IA (cada consulta cuesta tokens de Gemini/VirusTotal).

---

*Documento generado en Code Freeze — Sprint 11/10. Ningún archivo de código fue modificado.*
