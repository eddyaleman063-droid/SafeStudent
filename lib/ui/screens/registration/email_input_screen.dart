import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/l10n/app_localizations.dart';

class EmailInputScreen extends ConsumerWidget {
  final VoidCallback onContinue;

  const EmailInputScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final emailValid = ref.watch(funnelEmailValidProvider);

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                l.regEmailTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.regEmailDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 16,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: l.regEmailHint,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: dark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.15),
                  ),
                  filled: true,
                  fillColor: dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                  prefixIcon: const Icon(Icons.email_rounded, color: PremiumColors.primary, size: 20),
                ),
                onChanged: (value) {
                  ref.read(registrationFunnelProvider.notifier).setEmail(value);
                },
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: emailValid ? onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    disabledForegroundColor: dark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: emailValid ? 4 : 0,
                  ),
                  child: Text(l.continueText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
