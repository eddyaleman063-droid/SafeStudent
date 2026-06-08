import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../models/learning/lesson.dart';
import '../../../models/learning/stage.dart';
import '../../../services/experience_service.dart';
import '../../../ui/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  void _openLesson(WidgetRef ref, BuildContext context, String stageId, String lessonId, String title) {
    final exp = ExperienceService.instance;
    exp.lightHaptic();
    ref.read(sessionProvider.notifier).startSession(stageId, lessonId);
    context.pushNamed(
      'lesson-session',
      pathParameters: {
        'stageId': stageId,
        'lessonId': lessonId,
      },
      extra: title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final learning = ref.watch(learningProvider);
    final stages = learning.stages;

    if (learning.isLoading) {
      return Scaffold(
        backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerLoading(width: 140, height: 22),
                      const SizedBox(height: AppSpacing.lg),
                      const ShimmerLoading(width: 100, height: 14),
                      const SizedBox(height: AppSpacing.xs),
                      const ShimmerLoading(width: 50, height: 28),
                      const SizedBox(height: AppSpacing.md),
                      const ShimmerLoading(width: double.infinity, height: 4, borderRadius: AppRadius.pill),
                      const SizedBox(height: AppSpacing.xxl),
                      ...List.generate(3, (_) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: ShimmerLoading(width: double.infinity, height: 120, borderRadius: AppRadius.xl),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (learning.errorMessage != null) {
      return Scaffold(
        backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off_rounded, size: 64, color: dark ? Colors.white24 : Colors.black26),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    learning.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: dark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(learningProvider.notifier).reload(),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(AppLocalizations.of(context)!.tryAgain),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PremiumColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (stages.isEmpty) {
      return Scaffold(
        backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_rounded, size: 64, color: dark ? Colors.white24 : Colors.black26),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No hay lecciones disponibles. Vuelve pronto.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: dark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, 0),
              child: Row(
                children: [
                  Icon(Icons.map_rounded, size: 20, color: dark ? Colors.white54 : Colors.black54),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AppLocalizations.of(context)!.lessonsYourPath,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Row(
                children: [
                  _StatChip(
                    icon: Icons.check_circle_rounded,
                    label: AppLocalizations.of(context)!.lessonsCompleted(learning.lessonsCompleted),
                    color: PremiumColors.success,
                    dark: dark,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _StatChip(
                    icon: Icons.auto_awesome_rounded,
                    label: AppLocalizations.of(context)!.lessonsLevel(learning.currentLevel),
                    color: PremiumColors.xpColor,
                    dark: dark,
                  ),
                  const Spacer(),
                  Text(
                    '${(learning.overallProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: learning.overallProgress,
                backgroundColor: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                valueColor: const AlwaysStoppedAnimation<Color>(PremiumColors.success),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, 100),
                itemCount: stages.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (ctx, i) => _StageNode(
                  stage: stages[i],
                  index: i,
                  isLast: i == stages.length - 1,
                  dark: dark,
                  onLessonTap: (sid, lid, title) => _openLesson(ref, context, sid, lid, title),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool dark;
  const _StatChip({required this.icon, required this.label, required this.color, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: color.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}

typedef _LessonTapCallback = void Function(String stageId, String lessonId, String title);

class _StageNode extends StatelessWidget {
  final Stage stage;
  final int index;
  final bool isLast;
  final bool dark;
  final _LessonTapCallback? onLessonTap;
  const _StageNode({required this.stage, required this.index, required this.isLast, required this.dark, this.onLessonTap});

  @override
  Widget build(BuildContext context) {
    final completed = stage.isComplete;
    final unlocked = stage.unlocked;
    final hasProgress = stage.completedCount > 0 && !completed;

    final node = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed
                        ? PremiumColors.success
                        : unlocked
                            ? PremiumColors.primaryAccent
                            : (dark ? Colors.white12 : Colors.black12),
                    boxShadow: unlocked && !completed
                        ? [BoxShadow(color: PremiumColors.primaryAccent.withValues(alpha: 0.3), blurRadius: 8)]
                        : null,
                  ),
                  child: Icon(
                    completed
                        ? Icons.check_rounded
                        : unlocked
                            ? Icons.play_arrow_rounded
                            : Icons.lock_rounded,
                    size: 16,
                    color: completed || unlocked ? Colors.white : (dark ? Colors.white24 : Colors.black26),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: completed
                          ? PremiumColors.success.withValues(alpha: 0.4)
                          : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.08)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                color: unlocked
                    ? (dark ? PremiumColors.darkCard : Colors.white)
                    : (dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02)),
                border: Border.all(
                  color: completed
                      ? PremiumColors.success.withValues(alpha: 0.3)
                      : unlocked
                          ? PremiumColors.primaryAccent.withValues(alpha: 0.2)
                          : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
                ),
                boxShadow: unlocked && !completed
                    ? AppShadows.glow(color: PremiumColors.primaryAccent, intensity: 0.06, radius: 12)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: unlocked
                                ? (dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87)
                                : (dark ? Colors.white24 : Colors.black26),
                          ),
                        ),
                      ),
                      if (hasProgress)
                        Text(
                          '${stage.completedCount}/${stage.lessons.length}',
                          style: TextStyle(fontSize: 12, color: PremiumColors.primaryAccent.withValues(alpha: 0.7)),
                        ),
                      if (completed)
                        const Icon(Icons.check_circle_rounded, size: 18, color: PremiumColors.success),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    stage.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: unlocked
                          ? (dark ? Colors.white38 : Colors.black45)
                          : (dark ? Colors.white12 : Colors.black12),
                    ),
                  ),
                  if (!completed && unlocked && stage.completedCount > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: stage.progress,
                        backgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                        valueColor: const AlwaysStoppedAnimation<Color>(PremiumColors.primaryAccent),
                        minHeight: 3,
                      ),
                    ),
                  ],
                  if (unlocked) ...[
                    const SizedBox(height: AppSpacing.md),
                    ...stage.lessons.map((lesson) => _LessonRow(
                      lesson: lesson,
                      dark: dark,
                      onTap: stage.unlocked && !lesson.completed
                          ? () => onLessonTap?.call(stage.id, lesson.id, lesson.title)
                          : null,
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Hero(
      tag: 'stage_${stage.id}',
      child: node.animate(delay: (index * 60).ms).fadeIn(
        duration: 350.ms,
        curve: Curves.easeOut,
      ).slideX(begin: 0.08, end: 0, duration: 350.ms, curve: Curves.easeOut),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final bool dark;
  final VoidCallback? onTap;
  const _LessonRow({required this.lesson, required this.dark, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              lesson.completed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 16,
              color: lesson.completed
                  ? PremiumColors.success
                  : (dark ? Colors.white24 : Colors.black26),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 13,
                  color: lesson.completed
                      ? (dark ? Colors.white.withValues(alpha: 0.6) : Colors.black54)
                      : (dark ? Colors.white.withValues(alpha: 0.8) : Colors.black87),
                  decoration: lesson.completed ? TextDecoration.lineThrough : null,
                  decorationColor: dark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.minutes(lesson.estimatedMinutes),
              style: TextStyle(fontSize: 11, color: dark ? Colors.white24 : Colors.black26),
            ),
          ],
        ),
      ),
    );
  }
}
