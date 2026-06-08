import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sagen/services/storage_service.dart';
import 'package:sagen/services/streak_service.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  group('StreakService', () {
    late MockStorageService storage;
    late StreakService service;

    setUp(() {
      storage = MockStorageService();
      service = StreakService(storage);

      when(() => storage.getInt(any(), any())).thenReturn(0);
      when(() => storage.getString(any())).thenReturn('');
      when(() => storage.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => storage.setString(any(), any())).thenAnswer((_) async => true);
    });

    group('load', () {
      test('returns zero streak when no stored data', () {
        final status = service.load();

        expect(status.currentStreak, 0);
        expect(status.longestStreak, 0);
        expect(status.lastActivityDate, isNull);
        expect(status.streakFreezes, 0);
        expect(status.isAtRisk, false);
        expect(status.hasStreak, false);
        expect(status.isStreakFrozen, false);
        expect(status.tier, 'inactive');
      });

      test('loads saved streak values', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        when(() => storage.getInt('streak_current')).thenReturn(5);
        when(() => storage.getInt('streak_longest')).thenReturn(10);
        when(() => storage.getInt('streak_freezes')).thenReturn(2);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(yesterday.toIso8601String());

        final status = service.load();

        expect(status.currentStreak, 5);
        expect(status.longestStreak, 10);
        expect(status.streakFreezes, 2);
        expect(status.lastActivityDate, isNotNull);
        expect(status.tier, 'basic');
      });

      test('resets streak after 2+ days without freezes', () {
        final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
        when(() => storage.getInt('streak_current')).thenReturn(5);
        when(() => storage.getInt('streak_longest')).thenReturn(10);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(threeDaysAgo.toIso8601String());

        final status = service.load();

        expect(status.currentStreak, 0);
        expect(status.longestStreak, 10);
        expect(status.hasStreak, false);
      });

      test('uses freeze for 2-day gap', () {
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        when(() => storage.getInt('streak_current')).thenReturn(5);
        when(() => storage.getInt('streak_longest')).thenReturn(10);
        when(() => storage.getInt('streak_freezes')).thenReturn(1);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(twoDaysAgo.toIso8601String());

        final status = service.load();

        expect(status.currentStreak, 5);
        verify(() => storage.setInt('streak_freezes', 0)).called(1);
      });
    });

    group('checkIn', () {
      test('starts streak at 1 on first check-in', () {
        when(() => storage.getInt('streak_current')).thenReturn(0);
        when(() => storage.getInt('streak_longest')).thenReturn(0);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity')).thenReturn('');

        final status = service.checkIn();

        expect(status.currentStreak, 1);
        expect(status.longestStreak, 1);
        expect(status.hasStreak, true);
        expect(status.lastActivityDate, isNotNull);
      });

      test('increments streak for consecutive day check-in', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        when(() => storage.getInt('streak_current')).thenReturn(3);
        when(() => storage.getInt('streak_longest')).thenReturn(5);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(yesterday.toIso8601String());

        final status = service.checkIn();

        expect(status.currentStreak, 4);
        expect(status.longestStreak, 5);
      });

      test('returns same streak for same-day check-in', () {
        final today = DateTime.now();
        when(() => storage.getInt('streak_current')).thenReturn(3);
        when(() => storage.getInt('streak_longest')).thenReturn(5);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(today.toIso8601String());

        final status = service.checkIn();

        expect(status.currentStreak, 3);
      });

      test('resets streak after gap without freezes', () {
        final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
        when(() => storage.getInt('streak_current')).thenReturn(5);
        when(() => storage.getInt('streak_longest')).thenReturn(10);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(threeDaysAgo.toIso8601String());

        final status = service.checkIn();

        expect(status.currentStreak, 1);
        expect(status.longestStreak, 10);
      });

      test('limits freezes to 7', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        when(() => storage.getInt('streak_current')).thenReturn(5);
        when(() => storage.getInt('streak_longest')).thenReturn(10);
        when(() => storage.getInt('streak_freezes')).thenReturn(7);
        when(() => storage.getString('streak_last_activity'))
            .thenReturn(yesterday.toIso8601String());

        service.checkIn();

        verify(() => storage.setInt('streak_freezes', 7)).called(2);
      });
    });

    group('tier', () {
      test('returns inactive for streak 0', () {
        when(() => storage.getInt('streak_current')).thenReturn(0);
        final status = service.load();
        expect(status.tier, 'inactive');
      });

      test('returns basic for streak 1-6', () {
        when(() => storage.getInt('streak_current')).thenReturn(3);
        final status = service.load();
        expect(status.tier, 'basic');
      });

      test('returns glow for streak 7-13', () {
        when(() => storage.getInt('streak_current')).thenReturn(7);
        final status = service.load();
        expect(status.tier, 'glow');
      });

      test('returns particles for streak 14-29', () {
        when(() => storage.getInt('streak_current')).thenReturn(14);
        final status = service.load();
        expect(status.tier, 'particles');
      });

      test('returns crystal for streak 30-99', () {
        when(() => storage.getInt('streak_current')).thenReturn(30);
        final status = service.load();
        expect(status.tier, 'crystal');
      });

      test('returns legendary for streak 100+', () {
        when(() => storage.getInt('streak_current')).thenReturn(100);
        final status = service.load();
        expect(status.tier, 'legendary');
      });
    });

    group('shouldSendReminder', () {
      StreakStatus makeStatus({int streak = 5, bool atRisk = true}) {
        return StreakStatus(
          currentStreak: streak,
          longestStreak: streak,
          lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
          streakFreezes: 0,
          isAtRisk: atRisk,
          message: '',
          tier: 'basic',
        );
      }

      test('returns false when no streak', () {
        final status = makeStatus(streak: 0, atRisk: false);
        expect(service.shouldSendReminder(status), false);
      });

      test('returns false when not at risk', () {
        final status = makeStatus(atRisk: false);
        expect(service.shouldSendReminder(status), false);
      });

      test('returns true within 4 hours of midnight', () {
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day + 1);
        final hoursUntilMidnight = midnight.difference(now).inHours;
        final expected = hoursUntilMidnight <= 4 && hoursUntilMidnight > 0;

        final status = makeStatus(streak: 5, atRisk: true);
        expect(service.shouldSendReminder(status), expected);
      });
    });

    group('StreakStatus', () {
      test('timeUntilMidnight is positive', () {
        const status = StreakStatus(
          currentStreak: 1,
          longestStreak: 1,
          streakFreezes: 0,
          isAtRisk: false,
          message: '',
          tier: 'basic',
        );
        expect(status.timeUntilMidnight.inSeconds, greaterThan(0));
      });
    });

    group('mocktail verification', () {
      test('checkIn calls storage getters and setters', () {
        when(() => storage.getInt('streak_current')).thenReturn(0);
        when(() => storage.getInt('streak_longest')).thenReturn(0);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity')).thenReturn('');

        service.checkIn();

        verify(() => storage.getInt('streak_current')).called(1);
        verify(() => storage.getInt('streak_longest')).called(1);
        verify(() => storage.getInt('streak_freezes')).called(1);
        verify(() => storage.getString('streak_last_activity')).called(1);
        verify(() => storage.setInt('streak_current', 1)).called(2);
        verify(() => storage.setInt('streak_longest', 1)).called(2);
        verify(() => storage.setString('streak_last_activity', any())).called(2);
        verify(() => storage.setInt('streak_freezes', 1)).called(2);
      });

      test('load calls storage getters and setters', () {
        when(() => storage.getInt('streak_current')).thenReturn(0);
        when(() => storage.getInt('streak_longest')).thenReturn(0);
        when(() => storage.getInt('streak_freezes')).thenReturn(0);
        when(() => storage.getString('streak_last_activity')).thenReturn('');

        service.load();

        verify(() => storage.getInt('streak_current')).called(1);
        verify(() => storage.getInt('streak_longest')).called(1);
        verify(() => storage.getInt('streak_freezes')).called(1);
        verify(() => storage.getString('streak_last_activity')).called(1);
        verify(() => storage.setInt(any(), any())).called(3);
        verify(() => storage.setString(any(), any())).called(1);
      });
    });
  });
}
