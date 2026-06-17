enum PassRewardType { title, avatarFrame, cosmetic, chest, gems, xp, item }

class PassLevel {
  final int level;
  final int spRequired;
  final PassRewardType rewardType;
  final String rewardName;
  final int rewardValue;

  const PassLevel({
    required this.level,
    required this.spRequired,
    required this.rewardType,
    required this.rewardName,
    this.rewardValue = 0,
  });
}

class SagenPass {
  final int currentLevel;
  final int currentSP;
  final List<int> claimedLevels;
  final DateTime seasonStart;
  final int seasonDurationDays;

  SagenPass({
    this.currentLevel = 1,
    this.currentSP = 0,
    this.claimedLevels = const [],
    DateTime? seasonStart,
    this.seasonDurationDays = 30,
  }) : seasonStart = seasonStart ?? DateTime.now();

  SagenPass copyWith({
    int? currentLevel,
    int? currentSP,
    List<int>? claimedLevels,
    DateTime? seasonStart,
    int? seasonDurationDays,
  }) {
    return SagenPass(
      currentLevel: currentLevel ?? this.currentLevel,
      currentSP: currentSP ?? this.currentSP,
      claimedLevels: claimedLevels ?? this.claimedLevels,
      seasonStart: seasonStart ?? this.seasonStart,
      seasonDurationDays: seasonDurationDays ?? this.seasonDurationDays,
    );
  }

  static const int maxLevel = 50;
  static const int spPerLesson = 10;
  static const int spPerPerfectLesson = 15;
  static const int spPerMission = 5;

  int get spForNextLevel {
    if (currentLevel >= maxLevel) return 0;
    return 50 + (currentLevel - 1) * 10;
  }

  double get progressFraction => spForNextLevel > 0
      ? (currentSP / spForNextLevel).clamp(0.0, 1.0)
      : 1.0;

  bool get isMaxLevel => currentLevel >= maxLevel;

  bool isLevelClaimed(int level) => claimedLevels.contains(level);

  static final List<PassLevel> allLevels = List.generate(maxLevel, (i) {
    final level = i + 1;
    final sp = 50 + i * 10;
    if (level == 10) {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.avatarFrame,
        rewardName: 'Marco de Cobre',
      );
    } else if (level == 25) {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.chest,
        rewardName: 'Cofre Épico',
        rewardValue: 1,
      );
    } else if (level == 50) {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.cosmetic,
        rewardName: 'Llama Helada + Guardián',
      );
    } else if (level % 10 == 0) {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.chest,
        rewardName: 'Cofre Dorado',
        rewardValue: 1,
      );
    } else if (level % 5 == 0) {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.gems,
        rewardName: '100 Gemas',
        rewardValue: 100,
      );
    } else if (level % 3 == 0) {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.item,
        rewardName: 'Escudo de Titanio',
        rewardValue: 1,
      );
    } else {
      return PassLevel(
        level: level, spRequired: sp,
        rewardType: PassRewardType.xp,
        rewardName: '200 EXP',
        rewardValue: 200,
      );
    }
  });
}
