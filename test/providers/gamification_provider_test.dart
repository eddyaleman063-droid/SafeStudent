import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GamificationState', () {
    test('initial state has correct defaults', () {
      const state = GamificationState();
      expect(state.dailyGems, 0);
      expect(state.hasUnclaimedChest, false);
      expect(state.secondsUntilMidnight, 0);
      expect(state.dailyMissionsCompleted, 0);
    });

    test('copyWith updates only specified fields', () {
      const state = GamificationState();
      final updated = state.copyWith(dailyGems: 50, hasUnclaimedChest: true);
      expect(updated.dailyGems, 50);
      expect(updated.hasUnclaimedChest, true);
      expect(updated.dailyMissionsCompleted, 0);
    });
  });

  group('GamificationNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
    });

    tearDown(() => container.dispose());

    test('build returns default state', () {
      final state = container.read(gamificationProvider);
      expect(state.dailyGems, 0);
    });

    test('claimDailyChest returns gems and updates state', () {
      final notifier = container.read(gamificationProvider.notifier);
      final gems = notifier.claimDailyChest();
      expect(gems, greaterThan(0));
      final state = container.read(gamificationProvider);
      expect(state.dailyGems, gems);
      expect(state.hasUnclaimedChest, false);
    });

    test('incrementMission increments mission completed count', () {
      final notifier = container.read(gamificationProvider.notifier);
      notifier.incrementMission('mission_1');
      expect(container.read(gamificationProvider).dailyMissionsCompleted, 1);
    });

    test('incrementMission stacks multiple calls', () {
      final notifier = container.read(gamificationProvider.notifier);
      notifier.incrementMission('mission_1');
      notifier.incrementMission('mission_2');
      expect(container.read(gamificationProvider).dailyMissionsCompleted, 2);
    });

    test('onAdRewardEarned increments daily gems', () {
      final notifier = container.read(gamificationProvider.notifier);
      notifier.onAdRewardEarned();
      expect(container.read(gamificationProvider).dailyGems, 1);
    });

    test('onAdRewardEarned stacks multiple calls', () {
      final notifier = container.read(gamificationProvider.notifier);
      notifier.onAdRewardEarned();
      notifier.onAdRewardEarned();
      notifier.onAdRewardEarned();
      expect(container.read(gamificationProvider).dailyGems, 3);
    });
  });
}
