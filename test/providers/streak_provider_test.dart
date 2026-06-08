import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sagen/providers/providers.dart';

void main() {
  group('StreakNotifier', () {
    test('starts with zero streak', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      expect(notifier.currentStreak, 0);
      expect(notifier.longestStreak, 0);
      expect(notifier.streakFreezes, 0);
      expect(notifier.streakHistory, isEmpty);
    });
    test('tracks daily check-in', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      notifier.checkIn();
      expect(notifier.currentStreak, greaterThanOrEqualTo(1));
      expect(notifier.lastActivityDate, isNotNull);
    });
    test('provides emotional messages after check-in', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      notifier.checkIn();
      expect(notifier.emotionalMessages, isNotEmpty);
    });
    test('check-in increments streak', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      notifier.checkIn();
      final afterFirst = notifier.currentStreak;
      expect(afterFirst, greaterThanOrEqualTo(1));
    });
    test('monthly stats accessible', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      expect(notifier.monthlyStreakStats, isNotNull);
      expect(notifier.monthlyStreakStats.keys.length, 6);
    });
    test('weekly stats accessible', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      expect(notifier.weeklyStats, isNotNull);
    });
    test('heatmap data accessible', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      expect(notifier.heatmapData, isNotNull);
    });
    test('sets defrosting flag when check-in while frozen', () async {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String();
      SharedPreferences.setMockInitialValues({
        'streak_current': 5,
        'streak_longest': 5,
        'streak_freezes': 1,
        'streak_last_activity': yesterday,
      });
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(streakProvider.notifier);
      expect(notifier.isStreakFrozen, isTrue);
      notifier.checkIn();
      expect(notifier.isStreakFrozen, isFalse);
      await Future<void>.delayed(Duration.zero);
      expect(prefs.getBool('streak_just_defrosted'), isTrue);
    });
  });
}
