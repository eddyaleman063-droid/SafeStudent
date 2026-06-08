import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/l10n/app_localizations.dart';

class AgeInputScreen extends ConsumerWidget {
  final VoidCallback onContinue;

  const AgeInputScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(registrationFunnelProvider);
    final ageValid = ref.watch(funnelAgeValidProvider);

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
                l.regAgeQuestion,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 2,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 32,
                    color: dark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.1),
                  ),
                  filled: true,
                  fillColor: dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                onChanged: (value) {
                  final parsed = int.tryParse(value) ?? 0;
                  ref.read(registrationFunnelProvider.notifier).setAge(parsed);
                },
              ),
              if (state.age > 0 && !ageValid)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    l.regAgeValidation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: PremiumColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: ageValid ? onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    disabledForegroundColor: dark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: ageValid ? 4 : 0,
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
