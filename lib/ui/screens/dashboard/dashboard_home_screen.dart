import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../models/learning/stage.dart';
import '../../../services/experience_service.dart';
import '../../../ui/widgets/home/home_header.dart';
import '../../../ui/widgets/home/hero_mission_card.dart';
import '../../../ui/widgets/home/learning_track_tile.dart';
import '../../../ui/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class DashboardHomeScreen extends ConsumerStatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  ConsumerState<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends ConsumerState<DashboardHomeScreen> with AutomaticKeepAliveClientMixin {
  StageStatus _stageStatus(Stage stage) {
    if (!stage.unlocked) return StageStatus.locked;
    if (stage.isComplete) return StageStatus.completed;
    return StageStatus.inProgress;
  }

  Stage? _findStage(List<Stage> stages, String lessonId) {
    for (final s in stages) {
      if (s.lessons.any((l) => l.id == lessonId)) return s;
    }
    return null;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dash = ref.watch(dashboardProvider);
    final learning = ref.watch(learningProvider);

    final dark = Theme.of(context).brightness == Brightness.dark;

    if (learning.errorMessage != null) {
      return Scaffold(
        backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
        body: Center(
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
                  style: TextStyle(fontSize: 15, color: dark ? Colors.white54 : Colors.black54),
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
      );
    }

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: learning.isLoading
          ? const _DashboardShimmer()
          : SafeArea(
              child: RepaintBoundary(
                child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeHeader(
                      displayName: dash.displayName,
                      streak: dash.currentStreak,
                      gems: dash.gems,
                      greeting: dash.greeting,
                    ).animate().fadeIn(duration: 350.ms, curve: Curves.easeOut).slideY(
                      begin: -0.05,
                      end: 0,
                      duration: 350.ms,
                      curve: Curves.easeOut,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxl),
                      child: HeroMissionCard(
                        title: dash.nextLesson != null
                            ? dash.nextLesson!.title
                            : AppLocalizations.of(context)!.homeAllComplete,
                        subtitle: dash.nextLesson != null
                            ? '${dash.nextLessonStageTitle ?? ''} · ${dash.nextLesson!.estimatedMinutes} min'
                            : AppLocalizations.of(context)!.homeAllCompleteDesc,
                        actionLabel: dash.nextLesson != null ? AppLocalizations.of(context)!.homeContinue : AppLocalizations.of(context)!.homeViewAchievements,
                        onAction: () {
                          if (dash.nextLesson != null) {
                            final lesson = dash.nextLesson!;
                            final stage = _findStage(learning.stages, lesson.id);
                            if (stage != null) {
                              ExperienceService.instance.lightHaptic();
                              ref.read(sessionProvider.notifier).startSession(stage.id, lesson.id);
                              context.pushNamed(
                                'lesson-session',
                                pathParameters: {
                                  'stageId': stage.id,
                                  'lessonId': lesson.id,
                                },
                                extra: lesson.title,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        AppLocalizations.of(context)!.homeLearningPath,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.7),
                        ),
                      ).animate(delay: 200.ms).fadeIn(
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      ).slideX(begin: -0.03, end: 0, duration: 300.ms),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, 100,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final stage = learning.stages[index];
                          final status = _stageStatus(stage);
                          return LearningTrackTile(
                            stage: stage,
                            status: status,
                            index: index,
                            isLast: index == learning.stages.length - 1,
                            onTap: () {
                              ExperienceService.instance.lightHaptic();
                              context.pushNamed('lessons');
                            },
                          );
                        },
                        childCount: learning.stages.length,
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

class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                MediaQuery.of(context).padding.top + AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.lg,
              ),
              child: const Row(
                children: [
                  ShimmerLoading(width: 44, height: 44, borderRadius: AppRadius.pill),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(width: 80, height: 12),
                        SizedBox(height: 4),
                        ShimmerLoading(width: 120, height: 18),
                      ],
                    ),
                  ),
                  ShimmerLoading(width: 60, height: 28, borderRadius: AppRadius.pill),
                  SizedBox(width: AppSpacing.sm),
                  ShimmerLoading(width: 60, height: 28, borderRadius: AppRadius.pill),
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
            sliver: SliverToBoxAdapter(
              child: ShimmerLoading(width: double.infinity, height: 140, borderRadius: AppRadius.xl),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, 100),
            sliver: SliverToBoxAdapter(
              child: ShimmerLoading(width: double.infinity, height: 200, borderRadius: AppRadius.xl),
            ),
          ),
        ],
      ),
    );
  }
}
