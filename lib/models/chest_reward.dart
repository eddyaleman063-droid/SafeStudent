import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'chest_type.dart';

part 'chest_reward.freezed.dart';
part 'chest_reward.g.dart';

@freezed
class ChestReward with _$ChestReward {
  const factory ChestReward({
    @Default(0) int xp,
    @Default(0) int gems,
    int? streakShields,
    String? title,
    String? message,
    @Default(false) bool isPremium,
    @Default(false) bool xpBoost,
    @Default(false) bool gemMultiplier,
  }) = _ChestReward;

  factory ChestReward.fromJson(Map<String, dynamic> json) => _$ChestRewardFromJson(json);
}

class ChestSystem {
  static bool shouldUnlockChest(int lessonsCompleted) {
    if (lessonsCompleted <= 0) return false;
    return lessonsCompleted % 3 == 0 || lessonsCompleted % 5 == 0;
  }

  static bool isPremiumChest(int lessonsCompleted) {
    return lessonsCompleted > 0 && lessonsCompleted % 5 == 0;
  }
}

class ChestRewardRoller {
  static final _rng = Random();

  static ChestReward roll(ChestType type, {int? overrideXp, int? overrideGems}) {
    final xp = overrideXp ?? _rollXp(type);
    final gems = _rollGems(type) + (overrideGems ?? 0);
    final streakShields = _rollShield(type) ? 1 : null;
    final xpBoost = _rollBoost(type);
    final gemMultiplier = _rollMultiplier(type);

    return ChestReward(
      xp: xp,
      gems: gems,
      streakShields: streakShields,
      xpBoost: xpBoost,
      gemMultiplier: gemMultiplier,
    );
  }

  static int _rollXp(ChestType type) {
    switch (type) {
      case ChestType.bronze: return 15 + _rng.nextInt(11);
      case ChestType.silver: return 25 + _rng.nextInt(11);
      case ChestType.gold: return 35 + _rng.nextInt(16);
      case ChestType.legendary: return 50 + _rng.nextInt(26);
    }
  }

  static int _rollGems(ChestType type) {
    switch (type) {
      case ChestType.bronze: return 8 + _rng.nextInt(5);
      case ChestType.silver: return 16 + _rng.nextInt(9);
      case ChestType.gold: return 26 + _rng.nextInt(9);
      case ChestType.legendary:
        if (_rng.nextDouble() < 0.40) return 0;
        return 15 + _rng.nextInt(11);
    }
  }

  static bool _rollShield(ChestType type) {
    switch (type) {
      case ChestType.bronze: return false;
      case ChestType.silver: return false;
      case ChestType.gold: return false;
      case ChestType.legendary: return _rng.nextDouble() < 0.25;
    }
  }

  static bool _rollBoost(ChestType type) {
    switch (type) {
      case ChestType.bronze: return false;
      case ChestType.silver: return _rng.nextDouble() < 0.05;
      case ChestType.gold: return _rng.nextDouble() < 0.18;
      case ChestType.legendary: return _rng.nextDouble() < 0.35;
    }
  }

  static bool _rollMultiplier(ChestType type) {
    switch (type) {
      case ChestType.bronze: return false;
      case ChestType.silver: return false;
      case ChestType.gold: return _rng.nextDouble() < 0.06;
      case ChestType.legendary: return _rng.nextDouble() < 0.15;
    }
  }
}
