import '../services/streak_service.dart';

class StreakState {
  final StreakStatus status;
  final int totalCheckIns;
  final int perfectWeeks;
  final bool missionCompleted;
  final Map<String, int> weeklyStats;
  final Map<String, int> heatmapData;
  final Map<String, int> monthlyData;
  final List<String> streakHistory;
  final List<String> emotionalMessages;

  const StreakState({
    required this.status,
    required this.totalCheckIns,
    required this.perfectWeeks,
    required this.missionCompleted,
    required this.weeklyStats,
    required this.heatmapData,
    required this.monthlyData,
    required this.streakHistory,
    required this.emotionalMessages,
  });

  StreakState copyWith({
    StreakStatus? status,
    int? totalCheckIns,
    int? perfectWeeks,
    bool? missionCompleted,
    Map<String, int>? weeklyStats,
    Map<String, int>? heatmapData,
    Map<String, int>? monthlyData,
    List<String>? streakHistory,
    List<String>? emotionalMessages,
  }) {
    return StreakState(
      status: status ?? this.status,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      perfectWeeks: perfectWeeks ?? this.perfectWeeks,
      missionCompleted: missionCompleted ?? this.missionCompleted,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      heatmapData: heatmapData ?? this.heatmapData,
      monthlyData: monthlyData ?? this.monthlyData,
      streakHistory: streakHistory ?? this.streakHistory,
      emotionalMessages: emotionalMessages ?? this.emotionalMessages,
    );
  }

  int get currentStreak => status.currentStreak;
  bool get isStreakFrozen => status.isStreakFrozen;

  double get streakMultiplier {
    if (currentStreak < 10) return 1.0;
    final mult = 1.0 + (currentStreak ~/ 10) * 0.1;
    return mult.clamp(1.0, 2.0);
  }
}
