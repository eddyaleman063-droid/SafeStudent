import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../ui/widgets/common/sage_emotion_widget.dart';
import '../../../services/sage_emotion_service.dart';
import 'package:sagen/l10n/app_localizations.dart';

class ProfileHookScreen extends StatelessWidget {
  final VoidCallback onCreateProfile;
  final VoidCallback onSkipToHome;

  const ProfileHookScreen({
    super.key,
    required this.onCreateProfile,
    required this.onSkipToHome,
  });

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(
                width: 110,
                height: 110,
                child: SageEmotionWidget(
                  emotion: SageEmotion.happy,
                  size: 110,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l.regProfileAlmostReady,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.regProfileDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  color: dark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
                  border: Border.all(
                    color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: [
                    _BenefitRow2(icon: Icons.cloud_done_rounded, text: l.regCloudSave, dark: dark),
                    const SizedBox(height: AppSpacing.md),
                    _BenefitRow2(icon: Icons.local_fire_department_rounded, text: l.regStreakSync, dark: dark),
                    const SizedBox(height: AppSpacing.md),
                    _BenefitRow2(icon: Icons.auto_awesome_rounded, text: l.regRewards, dark: dark),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onCreateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: 4,
                  ),
                  child: Text(l.regCreateProfile, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onSkipToHome,
                child: Text(
                  l.regLater,
                  style: TextStyle(
                    fontSize: 13,
                    color: dark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitRow2 extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool dark;

  const _BenefitRow2({required this.icon, required this.text, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: PremiumColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: dark ? Colors.white.withValues(alpha: 0.7) : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
