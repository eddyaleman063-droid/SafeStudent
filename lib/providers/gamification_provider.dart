import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/gamification_repository.dart';
import 'prefs_provider.dart';

class GamificationState {
  final int dailyGems;
  final bool hasUnclaimedChest;
  final int secondsUntilMidnight;
  final int dailyMissionsCompleted;
  final bool adsAvailable;

  const GamificationState({
    this.dailyGems = 0,
    this.hasUnclaimedChest = false,
    this.secondsUntilMidnight = 0,
    this.dailyMissionsCompleted = 0,
    this.adsAvailable = false,
  });

  GamificationState copyWith({
    int? dailyGems,
    bool? hasUnclaimedChest,
    int? secondsUntilMidnight,
    int? dailyMissionsCompleted,
    bool? adsAvailable,
  }) {
    return GamificationState(
      dailyGems: dailyGems ?? this.dailyGems,
      hasUnclaimedChest: hasUnclaimedChest ?? this.hasUnclaimedChest,
      secondsUntilMidnight: secondsUntilMidnight ?? this.secondsUntilMidnight,
      dailyMissionsCompleted: dailyMissionsCompleted ?? this.dailyMissionsCompleted,
      adsAvailable: adsAvailable ?? this.adsAvailable,
    );
  }
}

class GamificationNotifier extends Notifier<GamificationState> {
  late final GamificationRepository _repo;

  @override
  GamificationState build() {
    final prefs = ref.watch(prefsProvider);
    _repo = GamificationRepository(prefs);
    _repo.checkMidnightReset();
    return GamificationState(
      hasUnclaimedChest: _repo.canClaimDailyChest,
      secondsUntilMidnight: _repo.secondsUntilMidnight,
    );
  }

  int claimDailyChest() {
    final gems = _repo.claimDailyChest();
    state = state.copyWith(
      dailyGems: state.dailyGems + gems,
      hasUnclaimedChest: false,
    );
    return gems;
  }

  void incrementMission(String missionId, {int amount = 1}) {
    _repo.incrementMission(missionId, amount: amount);
    state = state.copyWith(
      dailyMissionsCompleted: state.dailyMissionsCompleted + 1,
    );
  }

  void onAdRewardEarned() {
    state = state.copyWith(dailyGems: state.dailyGems + 1);
  }
}

final gamificationProvider = NotifierProvider<GamificationNotifier, GamificationState>(GamificationNotifier.new);
