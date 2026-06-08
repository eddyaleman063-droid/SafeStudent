import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/l10n/app_localizations.dart';

class NameInputScreen extends ConsumerWidget {
  final VoidCallback onContinue;

  const NameInputScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final nameValid = ref.watch(funnelNameValidProvider);
    final notifier = ref.read(registrationFunnelProvider.notifier);

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
                l.regNameQuestion,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                style: TextStyle(
                  fontSize: 16,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: l.regNameHint,
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
                  prefixIcon: const Icon(Icons.person_rounded, color: PremiumColors.primary, size: 20),
                ),
                onChanged: (value) => notifier.setName(value),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                style: TextStyle(
                  fontSize: 16,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: l.regSurnameHint,
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
                  prefixIcon: const Icon(Icons.badge_rounded, color: PremiumColors.primary, size: 20),
                ),
                onChanged: (value) => notifier.setSurname(value),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: nameValid ? onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    disabledForegroundColor: dark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: nameValid ? 4 : 0,
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
