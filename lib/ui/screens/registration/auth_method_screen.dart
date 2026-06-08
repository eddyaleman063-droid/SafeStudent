import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/l10n/app_localizations.dart';

class AuthMethodScreen extends ConsumerWidget {
  final VoidCallback onContinue;

  const AuthMethodScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                l.regHowContinue,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.regChooseMethod,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              GestureDetector(
                onTap: () {
                  ref.read(registrationFunnelProvider.notifier).setAuthMethod('google');
                  onContinue();
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    color: dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                    border: Border.all(
                      color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/ui/google_logo.png', width: 24, height: 24),
                      const SizedBox(width: AppSpacing.lg),
                      Text(
                        l.authGoogleButton,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () {
                  ref.read(registrationFunnelProvider.notifier).setAuthMethod('email');
                  onContinue();
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    color: dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                    border: Border.all(
                      color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email_rounded, size: 24, color: PremiumColors.primary),
                      const SizedBox(width: AppSpacing.lg),
                      Text(
                        l.regEmailOption,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
