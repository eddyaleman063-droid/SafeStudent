import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import '../../../ui/widgets/common/sage_emotion_widget.dart';
import '../../../services/sage_emotion_service.dart';
import 'package:sagen/l10n/app_localizations.dart';

class ProfileSuccessScreen extends ConsumerStatefulWidget {
  const ProfileSuccessScreen({super.key});

  @override
  ConsumerState<ProfileSuccessScreen> createState() => _ProfileSuccessScreenState();
}

class _ProfileSuccessScreenState extends ConsumerState<ProfileSuccessScreen> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    if (!_navigating) {
      _navigating = true;
      final notifier = ref.read(registrationFunnelProvider.notifier);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) {
          notifier.reset();
          context.goNamed('main');
        }
      });
    }

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
                width: 120,
                height: 120,
                child: SageEmotionWidget(
                  emotion: SageEmotion.surprisedWings,
                  size: 120,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  gradient: const LinearGradient(colors: PremiumColors.gradientAchievement),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l.regProfileCreated,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l.regWelcomeSagen,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.regReadyForLesson,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                ),
              ),
              const Spacer(flex: 2),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(PremiumColors.splashBlue),
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
