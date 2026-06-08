import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/services/experience_service.dart';
import 'package:sagen/ui/widgets/common/sage_emotion_widget.dart';
import 'package:sagen/services/sage_emotion_service.dart';
import 'package:sagen/ui/widgets/common/sagen_touch_response.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exp = ExperienceService.instance;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top block: robot + brand ──────────────────────
            RepaintBoundary(
              child: Expanded(
                flex: 4,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const RepaintBoundary(
                        child: SageEmotionWidget(
                          emotion: SageEmotion.excitedWave,
                          size: 160,
                          animated: true,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l.appName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: PremiumColors.primaryAccent.withValues(alpha: 0.95),
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Tagline ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.huge,
              ),
              child: Text(
                l.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.50),
                  height: 1.5,
                ),
              ),
            ),
            // ── Buttons ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                children: [
                  SagenTouchResponse(
                    onTap: () {
                      exp.lightHaptic();
                      context.pushNamed('onboarding');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        color: PremiumColors.primaryAccent,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [
                          BoxShadow(
                            color: PremiumColors.primaryAccent.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l.welcomeStartButton,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SagenTouchResponse(
                    onTap: () {
                      exp.lightHaptic();
                      context.pushNamed('login');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l.welcomeLoginButton,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.80),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
