import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/providers/providers.dart';

void main() {
  group('DashboardState', () {
    test('initial state has correct defaults', () {
      const state = DashboardState();
      expect(state.displayName, '');
      expect(state.gems, 0);
      expect(state.xp, 0);
      expect(state.level, 1);
      expect(state.nextLevelXp, 100);
      expect(state.isLoading, true);
      expect(state.activeTab, 0);
      expect(state.dailyGoalMinutes, 0);
    });

    test('dailyProgress returns 0 when dailyGoalMinutes is 0', () {
      const state = DashboardState();
      expect(state.dailyProgress, 0);
    });

    test('dailyProgress clamps between 0 and 1', () {
      const state = DashboardState(dailyGoalMinutes: 10, lessonsCompletedToday: 5);
      expect(state.dailyProgress, 1.0);
    });

    test('dailyProgress returns proportional value', () {
      const state = DashboardState(dailyGoalMinutes: 20, lessonsCompletedToday: 1);
      expect(state.dailyProgress, 0.5);
    });

    test('copyWith updates only specified fields', () {
      const state = DashboardState();
      final updated = state.copyWith(displayName: 'Test', gems: 50, level: 3);
      expect(updated.displayName, 'Test');
      expect(updated.gems, 50);
      expect(updated.level, 3);
      expect(updated.xp, 0);
      expect(updated.isLoading, true);
    });

    test('greeting returns a non-empty string', () {
      const state = DashboardState();
      expect(state.greeting, isNotEmpty);
    });
  });

  group('DashboardNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('build returns default state', () {
      final state = container.read(dashboardProvider);
      expect(state.isLoading, true);
      expect(state.gems, 0);
    });

    test('setActiveTab changes the active tab', () {
      final notifier = container.read(dashboardProvider.notifier);
      notifier.setActiveTab(2);
      expect(container.read(dashboardProvider).activeTab, 2);
    });

    test('setActiveTab ignores same index', () {
      final notifier = container.read(dashboardProvider.notifier);
      notifier.setActiveTab(0);
      expect(container.read(dashboardProvider).activeTab, 0);
    });

    test('setDailyGoalMinutes updates the daily goal', () {
      final notifier = container.read(dashboardProvider.notifier);
      notifier.setDailyGoalMinutes(15);
      expect(container.read(dashboardProvider).dailyGoalMinutes, 15);
    });

    test('updateFrom sets all fields and clears loading', () {
      final notifier = container.read(dashboardProvider.notifier);
      notifier.updateFrom(
        displayName: 'Test User',
        gems: 100,
        xp: 50,
        level: 2,
        nextLevelXp: 200,
        levelProgress: 0.25,
        currentStreak: 5,
        longestStreak: 10,
        dailyGoalMinutes: 15,
        lessonsCompletedToday: 2,
        stages: [],
      );
      final state = container.read(dashboardProvider);
      expect(state.displayName, 'Test User');
      expect(state.gems, 100);
      expect(state.xp, 50);
      expect(state.level, 2);
      expect(state.currentStreak, 5);
      expect(state.longestStreak, 10);
      expect(state.isLoading, false);
    });

    test('getters return state values', () {
      final notifier = container.read(dashboardProvider.notifier);
      notifier.setActiveTab(1);
      expect(notifier.activeTab, 1);
      expect(notifier.displayName, '');
      expect(notifier.gems, 0);
      expect(notifier.isLoading, true);
    });
  });
}
