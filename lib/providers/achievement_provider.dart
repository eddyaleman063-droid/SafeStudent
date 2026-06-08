import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/achievement_service.dart';
import 'prefs_provider.dart';

class AchievementState {
  final bool isInitialized;
  final List<AchievementModel> achievements;
  final int unlockedCount;
  final int totalCount;
  final double progress;

  const AchievementState({
    this.isInitialized = false,
    this.achievements = const [],
    this.unlockedCount = 0,
    this.totalCount = 0,
    this.progress = 0.0,
  });

  AchievementState copyWith({
    bool? isInitialized,
    List<AchievementModel>? achievements,
    int? unlockedCount,
    int? totalCount,
    double? progress,
  }) {
    return AchievementState(
      isInitialized: isInitialized ?? this.isInitialized,
      achievements: achievements ?? this.achievements,
      unlockedCount: unlockedCount ?? this.unlockedCount,
      totalCount: totalCount ?? this.totalCount,
      progress: progress ?? this.progress,
    );
  }
}

class AchievementNotifier extends Notifier<AchievementState> {
  @override
  AchievementState build() {
    final prefs = ref.watch(prefsProvider);
    AchievementProvider.unlockDelegate = (id) => unlockAchievement(id);
    _init(prefs);
    return const AchievementState();
  }

  Future<void> _init(SharedPreferences prefs) async {
    final service = AchievementService.instance;
    await service.init(prefs);
    state = AchievementState(
      isInitialized: true,
      achievements: service.achievements,
      unlockedCount: service.unlockedCount,
      totalCount: service.totalCount,
      progress: service.progress,
    );
  }

  bool unlockAchievement(String id) {
    final service = AchievementService.instance;
    final unlocked = service.unlock(id);
    if (unlocked) {
      state = state.copyWith(
        achievements: service.achievements,
        unlockedCount: service.unlockedCount,
        totalCount: service.totalCount,
        progress: service.progress,
      );
    }
    return unlocked;
  }
}

// Backward-compat wrapper for non-Riverpod consumers (learning_provider, etc.)
class AchievementProvider {
  AchievementProvider._();

  static AchievementProvider? _instance;
  static AchievementProvider get instance {
    _instance ??= AchievementProvider._();
    return _instance!;
  }

  bool unlockAchievement(String id) => _unlockDelegate?.call(id) ?? false;

  static bool Function(String id)? _unlockDelegate;
  static set unlockDelegate(bool Function(String id)? fn) => _unlockDelegate = fn;
}
