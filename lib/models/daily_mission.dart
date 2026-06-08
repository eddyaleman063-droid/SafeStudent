import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_mission.freezed.dart';
part 'daily_mission.g.dart';

@JsonEnum()
enum MissionType { completeLesson, talkToSage, analyzeLink, perfectLesson, maintainStreak, quickChallenge, detectPhishing }

@JsonEnum()
enum MissionDifficulty { easy, medium, hard }

@JsonEnum()
enum MissionRarity { common, rare, epic }

@JsonEnum()
enum MissionCategory { learning, protection, consistency, awareness, privacy, safeHabits }

@unfreezed
class DailyMission with _$DailyMission {
  DailyMission._();

  factory DailyMission({
    required String id,
    required String title,
    required String description,
    required MissionType type,
    @Default(30) int xpReward,
    @Default(10) int gemReward,
    @Default(1) int target,
    @Default(MissionDifficulty.easy) MissionDifficulty difficulty,
    @Default(MissionRarity.common) MissionRarity rarity,
    @Default(0) int xpBonus,
    @Default(0) int gemBonus,
    @Default(0) int streakBonus,
    @Default(MissionCategory.learning) MissionCategory category,
    @Default(0) int progress,
    @Default(false) bool completed,
  }) = _DailyMission;

  factory DailyMission.fromJson(Map<String, dynamic> json) => _$DailyMissionFromJson(json);

  double get progressFraction => target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
}
