import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/onboarding_wizard_config.dart';
import '../../../core/theme/theme_constants.dart';

class WizardTopBar extends ConsumerWidget {
  final int currentIndex;
  final VoidCallback onBack;
  final bool isDark;

  const WizardTopBar({
    super.key,
    required this.currentIndex,
    required this.onBack,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (currentIndex + 1) / OnboardingWizardConfig.totalSteps;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 22),
            color: isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF1A1A2E).withValues(alpha: 0.7),
            onPressed: onBack,
            splashRadius: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  PremiumColors.splashBlue.withValues(alpha: 0.8),
                ),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
