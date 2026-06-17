import '../models/learning/stage.dart';

class LearningState {
  final List<Stage> stages;
  final int gems;
  final int xp;
  final int currentLevel;
  final int lessonsCompleted;
  final List<String> achievements;
  final int totalXpEarned;
  final int totalGemsEarned;
  final bool isLoading;
  final String? errorMessage;

  const LearningState({
    this.stages = const [],
    this.gems = 0,
    this.xp = 0,
    this.currentLevel = 1,
    this.lessonsCompleted = 0,
    this.achievements = const [],
    this.totalXpEarned = 0,
    this.totalGemsEarned = 0,
    this.isLoading = true,
    this.errorMessage,
  });

  LearningState copyWith({
    List<Stage> Function()? stages,
    int? gems,
    int? xp,
    int? currentLevel,
    int? lessonsCompleted,
    List<String> Function()? achievements,
    int? totalXpEarned,
    int? totalGemsEarned,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return LearningState(
      stages: stages != null ? stages() : this.stages,
      gems: gems ?? this.gems,
      xp: xp ?? this.xp,
      currentLevel: currentLevel ?? this.currentLevel,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      achievements: achievements != null ? achievements() : this.achievements,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      totalGemsEarned: totalGemsEarned ?? this.totalGemsEarned,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  double get overallProgress {
    if (stages.isEmpty) return 0;
    final total = stages.fold<int>(0, (s, stage) => s + stage.sessions.fold<int>(0, (ss, ses) => ss + ses.lessons.length));
    final done = stages.fold<int>(0, (s, stage) => s + stage.completedCount);
    if (total == 0) return 0;
    return done / total;
  }

  int get nextLevelXp => currentLevel * 100;
  double get levelProgress => totalXpEarned % nextLevelXp / nextLevelXp;
}
