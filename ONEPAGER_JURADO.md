# SAGEN — Seguridad Digital para Estudiantes

## El Problema
El 60% de estudiantes peruanos ha sufrido ciberacoso o estafas digitales. Las herramientas existentes son complejas, están en inglés o requieren conexión constante. En zonas rurales sin internet ni tarjeta de crédito, la protección digital simplemente no existe.

## La Solución — Arquitectura SAGEN
App offline-first que combina educación interactiva, análisis de malware y un asistente IA (SageAI) — todo en un solo ecosistema gamificado. Stack técnico: Flutter + Riverpod + Firebase, con 122 tests automatizados y 0 errores de análisis estático. Escalable, testeada y preparada para producción.

## Modelo de Negocio — Híbrido Cero-Costo Fijo
| Capa | Mecanismo | Ingreso |
|---|---|---|
| **Freemium** | 5 gemas gratis/día (cofre + misiones) → 1 análisis IA sin pagar | Retención y tracción |
| **AdMob** | Rewarded ads: usuario ve 30s → gana 1 gema | ~$1–6 USD CPD / 1,000 DAU |
| **P2P WhatsApp** | Paquetes de 50–300 gemas por S/5–S/20, pago vía Yape/Plin | 0% comisión, liquidez inmediata |

Sin servidores backend, sin pasarela financiera, sin comisiones. La monetización no penaliza al usuario gratuito.

## Resultados Técnicos
- **122 tests unitarios y de widget** — 100% passing
- **0 issues en flutter analyze** (0 warnings, 0 errors)
- **0 dependencias de backend** — infraestructura cero, costo de hosting = $0
- **Anti-cheat por fecha UTC** — sin necesidad de NTP externo
- **Notificaciones push locales a las 20:00** — retención sin Firebase Cloud Messaging
- **Código ofuscado** con `--obfuscate --split-debug-info` para seguridad IP

---

*Más información: https://sagen.app* | *Repositorio: github.com/Eddybel/SAGENAPP*
