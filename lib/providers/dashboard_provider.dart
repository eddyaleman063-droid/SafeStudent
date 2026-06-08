import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learning/lesson.dart';
import '../models/learning/stage.dart';

class DashboardState {
  final String displayName;
  final int gems;
  final int xp;
  final int level;
  final int nextLevelXp;
  final double levelProgress;
  final int currentStreak;
  final int longestStreak;
  final int dailyGoalMinutes;
  final int lessonsCompletedToday;
  final Lesson? nextLesson;
  final String? nextLessonStageTitle;
  final bool isLoading;
  final int activeTab;

  const DashboardState({
    this.displayName = '',
    this.gems = 0,
    this.xp = 0,
    this.level = 1,
    this.nextLevelXp = 100,
    this.levelProgress = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.dailyGoalMinutes = 0,
    this.lessonsCompletedToday = 0,
    this.nextLesson,
    this.nextLessonStageTitle,
    this.isLoading = true,
    this.activeTab = 0,
  });

  DashboardState copyWith({
    String? displayName,
    int? gems,
    int? xp,
    int? level,
    int? nextLevelXp,
    double? levelProgress,
    int? currentStreak,
    int? longestStreak,
    int? dailyGoalMinutes,
    int? lessonsCompletedToday,
    Lesson? Function()? nextLesson,
    String? Function()? nextLessonStageTitle,
    bool? isLoading,
    int? activeTab,
  }) {
    return DashboardState(
      displayName: displayName ?? this.displayName,
      gems: gems ?? this.gems,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      nextLevelXp: nextLevelXp ?? this.nextLevelXp,
      levelProgress: levelProgress ?? this.levelProgress,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      lessonsCompletedToday: lessonsCompletedToday ?? this.lessonsCompletedToday,
      nextLesson: nextLesson != null ? nextLesson() : this.nextLesson,
      nextLessonStageTitle: nextLessonStageTitle != null ? nextLessonStageTitle() : this.nextLessonStageTitle,
      isLoading: isLoading ?? this.isLoading,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  double get dailyProgress {
    if (dailyGoalMinutes <= 0) return 0;
    return (lessonsCompletedToday * 10 / dailyGoalMinutes).clamp(0, 1);
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() => const DashboardState();

  String get displayName => state.displayName;
  int get gems => state.gems;
  int get xp => state.xp;
  int get level => state.level;
  int get nextLevelXp => state.nextLevelXp;
  double get levelProgress => state.levelProgress;
  int get currentStreak => state.currentStreak;
  int get longestStreak => state.longestStreak;
  int get dailyGoalMinutes => state.dailyGoalMinutes;
  int get lessonsCompletedToday => state.lessonsCompletedToday;
  Lesson? get nextLesson => state.nextLesson;
  String? get nextLessonStageTitle => state.nextLessonStageTitle;
  bool get isLoading => state.isLoading;
  int get activeTab => state.activeTab;
  String get greeting => state.greeting;
  double get dailyProgress => state.dailyProgress;

  void setActiveTab(int index) {
    if (index == state.activeTab) return;
    state = state.copyWith(activeTab: index);
  }

  void setDailyGoalMinutes(int minutes) {
    state = state.copyWith(dailyGoalMinutes: minutes);
  }

  void updateFrom({
    required String displayName,
    required int gems,
    required int xp,
    required int level,
    required int nextLevelXp,
    required double levelProgress,
    required int currentStreak,
    required int longestStreak,
    required int dailyGoalMinutes,
    required int lessonsCompletedToday,
    required List<Stage> stages,
  }) {
    Lesson? nextLesson;
    String? nextLessonStageTitle;
    for (final stage in stages) {
      final next = stage.nextLesson;
      if (next != null && !next.completed) {
        nextLesson = next;
        nextLessonStageTitle = stage.title;
        break;
      }
    }

    state = state.copyWith(
      displayName: displayName,
      gems: gems,
      xp: xp,
      level: level,
      nextLevelXp: nextLevelXp,
      levelProgress: levelProgress,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      dailyGoalMinutes: dailyGoalMinutes,
      lessonsCompletedToday: lessonsCompletedToday,
      nextLesson: () => nextLesson,
      nextLessonStageTitle: () => nextLessonStageTitle,
      isLoading: false,
    );
  }
}
