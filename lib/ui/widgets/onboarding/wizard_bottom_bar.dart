import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/config/onboarding_wizard_config.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/services/experience_service.dart';

class WizardBottomBar extends ConsumerWidget {
  final int currentIndex;
  final bool canContinue;
  final bool isDark;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const WizardBottomBar({
    super.key,
    required this.currentIndex,
    required this.canContinue,
    required this.isDark,
    required this.onNext,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final exp = ExperienceService.instance;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentIndex == 0)
            WizardButton(
              label: l.startText,
              enabled: true,
              isDark: isDark,
              onPressed: onNext,
            )
          else if (currentIndex == OnboardingWizardConfig.totalSteps - 1) ...[
            WizardButton(
              label: l.onboardingCommitButton,
              enabled: canContinue,
              isDark: isDark,
              onPressed: onComplete,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                exp.lightHaptic();
                context.goNamed('login', queryParameters: {'onboarding': 'true'});
              },
              child: Text(
                l.onboardingHaveAccount,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white.withValues(alpha: 0.35) : const Color(0xFF1A1A2E).withValues(alpha: 0.35),
                ),
              ),
            ),
          ] else
            WizardButton(
              label: l.continueText,
              enabled: canContinue,
              isDark: isDark,
              onPressed: onNext,
            ),
        ],
      ),
    );
  }
}

class WizardButton extends StatefulWidget {
  final String label;
  final bool enabled;
  final bool isDark;
  final VoidCallback onPressed;

  const WizardButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<WizardButton> createState() => _WizardButtonState();
}

class _WizardButtonState extends State<WizardButton> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _shimmerAnim = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOutSine),
    );
    _shimmerCtrl.repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exp = ExperienceService.instance;
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, _) {
        return AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppEasing.entrance,
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: widget.enabled
                ? LinearGradient(
                    colors: [
                      PremiumColors.splashBlue,
                      PremiumColors.splashBlue.withValues(alpha: 0.8),
                      PremiumColors.splashBlue,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment(_shimmerAnim.value - 1, 0),
                    end: Alignment(_shimmerAnim.value + 1, 0),
                  )
                : null,
            color: widget.enabled ? null : (widget.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)),
            boxShadow: widget.enabled && !exp.reduceShadows
                ? [
                    BoxShadow(
                      color: PremiumColors.splashBlue.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: widget.enabled
                  ? () {
                      exp.lightHaptic();
                      widget.onPressed();
                    }
                  : null,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: AppMotion.fast,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.enabled
                        ? Colors.white
                        : (widget.isDark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25)),
                  ),
                  child: Text(widget.label),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
