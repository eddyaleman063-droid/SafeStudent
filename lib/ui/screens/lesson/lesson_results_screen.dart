import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/experience_service.dart';
import 'package:sagen/l10n/app_localizations.dart';
import '../../widgets/streak/flame_animation_widget.dart';

class LessonResultsScreen extends ConsumerWidget {
  final String stageId;
  final String lessonId;
  const LessonResultsScreen({
    super.key,
    required this.stageId,
    required this.lessonId,
  });

  void _finishLesson(BuildContext context, WidgetRef ref, SessionState session) {
    final exp = ExperienceService.instance;
    exp.successHaptic();
    ref.read(streakProvider.notifier).checkIn();
    ref.read(learningProvider.notifier).completeLesson(
      stageId,
      lessonId,
      perfectLesson: session.isPerfect,
    );
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);

    if (session.phase == SessionPhase.intro) {
      return Scaffold(
        backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Preparando resultados...',
                style: TextStyle(fontSize: 15, color: dark ? Colors.white54 : Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: FlameAnimationWidget(phase: null),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              if (session.isPerfect) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    gradient: const LinearGradient(
                      colors: PremiumColors.gradientAchievement,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.white),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        l.resultPerfectBadge,
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
                const SizedBox(height: AppSpacing.lg),
              ],
              Icon(
                session.isPerfect ? Icons.emoji_events_rounded : Icons.check_circle_rounded,
                size: 72,
                color: session.isPerfect
                    ? PremiumColors.streakOrange
                    : PremiumColors.success,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                session.isPerfect ? l.resultPerfectTitle : l.resultCompleteTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                session.isPerfect ? l.resultPerfectDesc : l.resultNotPerfectDesc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: dark ? Colors.white38 : Colors.black45),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ResultBadge(
                    icon: Icons.auto_awesome_rounded,
                    value: '+${session.earnedXp}',
                    label: l.profileXpLabel,
                    color: PremiumColors.xpColor,
                    dark: dark,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _ResultBadge(
                    icon: Icons.check_circle_rounded,
                    value: '${(session.accuracy * 100).toInt()}%',
                    label: l.resultAccuracy,
                    color: PremiumColors.success,
                    dark: dark,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _ResultBadge(
                    icon: Icons.favorite_rounded,
                    value: '${session.lives}',
                    label: l.resultLives,
                    color: Colors.red.shade400,
                    dark: dark,
                  ),
                ],
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _finishLesson(context, ref, session),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: 4,
                  ),
                  child: Text(l.continueText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool dark;
  const _ResultBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: dark ? Colors.white38 : Colors.black45),
          ),
        ],
      ),
    );
  }
}
