import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/config/app_config.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/payment_provider.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import 'package:url_launcher/url_launcher.dart';

class GemPackage {
  final int gems;
  final double price;
  final String labelKey;

  const GemPackage(this.gems, this.price, this.labelKey);

  String localizedLabel(AppLocalizations l) {
    switch (labelKey) {
      case 'paywallBasic': return l.paywallBasic;
      case 'paywallPopular': return l.paywallPopular;
      case 'paywallPremium': return l.paywallPremium;
      default: return labelKey;
    }
  }
}

const gemPackages = [
  GemPackage(50, 5.00, 'paywallBasic'),
  GemPackage(120, 10.00, 'paywallPopular'),
  GemPackage(300, 20.00, 'paywallPremium'),
];

class PaywallBottomSheet extends ConsumerWidget {
  final String? userId;

  const PaywallBottomSheet({super.key, this.userId});

  static const String _whatsAppNumber = '51934890627';

  static Future<void> show(BuildContext context, {String? userId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaywallBottomSheet(userId: userId),
    );
  }

  Future<void> _processLocalPayment(BuildContext context, GemPackage pkg, String? uid) async {
    final l = AppLocalizations.of(context)!;
    final userId = uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final message = l.paywallWhatsAppMessage(pkg.gems, pkg.price.toStringAsFixed(2), userId);

    try {
      final uri = Uri.https('wa.me', '/$_whatsAppNumber', {'text': message});
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          SagenNotification.show(context, message: l.paywallWhatsAppFallback(message));
        }
      }
    } catch (e) {
      if (context.mounted) {
        SagenNotification.show(context, message: l.paywallWhatsAppError(AppConfig.mercadopagoLink));
      }
    }
  }

  Future<void> _processMpPayment(BuildContext context, WidgetRef ref, GemPackage pkg) async {
    final l = AppLocalizations.of(context)!;
    final initPoint = await ref.read(paymentProvider.notifier).initiateMercadoPago(
      gems: pkg.gems,
      price: pkg.price,
    );

    if (initPoint == null) {
      if (context.mounted) {
        SagenNotification.show(
          context,
          message: 'Error al conectar con Mercado Pago. Intenta de nuevo.',
          type: NotificationType.error,
        );
      }
      return;
    }

    try {
      await launchUrl(Uri.parse(initPoint), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        SagenNotification.show(
          context,
          message: l.paywallWhatsAppError(AppConfig.mercadopagoLink),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final paymentState = ref.watch(paymentProvider);

    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0D1117) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: dark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l.paywallGetMoreGems,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.paywallDescription,
            style: TextStyle(
              fontSize: 13,
              color: dark ? Colors.white38 : Colors.black45,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...gemPackages.map((pkg) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              children: [
                _PackageCard(
                  pkg: pkg,
                  dark: dark,
                  onTap: () => _processLocalPayment(context, pkg, userId),
                ),
                const SizedBox(height: AppSpacing.xs),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: paymentState.status == PaymentStatus.creatingPreference
                        ? null
                        : () => _processMpPayment(context, ref, pkg),
                    icon: paymentState.status == PaymentStatus.creatingPreference
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.payment_rounded, size: 18),
                    label: Text(
                      'Mercado Pago',
                      style: TextStyle(
                        fontSize: 13,
                        color: dark ? Colors.cyanAccent : const Color(0xFF009EE3),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: dark ? Colors.cyanAccent : const Color(0xFF009EE3),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              l.paywallPaymentMethods,
              style: TextStyle(
                fontSize: 11,
                color: dark ? Colors.white24 : Colors.black26,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final GemPackage pkg;
  final bool dark;
  final VoidCallback onTap;

  const _PackageCard({required this.pkg, required this.dark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: dark ? const Color(0xFF1A1F2E) : PremiumColors.primary.withValues(alpha: 0.05),
          border: Border.all(
            color: PremiumColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: const LinearGradient(
                  colors: [PremiumColors.primary, PremiumColors.primaryAccent],
                ),
              ),
              child: const Icon(Icons.diamond_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.paywallPackageGems(pkg.gems),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    l.paywallPackageLabel(pkg.localizedLabel(l).toLowerCase()),
                    style: TextStyle(fontSize: 12, color: dark ? Colors.white38 : Colors.black45),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                color: PremiumColors.primary,
              ),
              child: Text(
                'S/${pkg.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
