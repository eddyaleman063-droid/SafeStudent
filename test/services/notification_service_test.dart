import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    test('is a singleton', () {
      final a = NotificationService.instance;
      final b = NotificationService.instance;
      expect(a, same(b));
    });

    test('scheduleChestReminder is no-op when not initialized', () async {
      await NotificationService.instance.scheduleChestReminder();
    });

    test('scheduleStreakReminder is no-op when not initialized', () async {
      await NotificationService.instance.scheduleStreakReminder(5);
    });

    test('cancelAll is no-op when not initialized', () async {
      await NotificationService.instance.cancelAll();
    });

    test('cancelStreakReminder is no-op when not initialized', () async {
      await NotificationService.instance.cancelStreakReminder();
    });

    test('scheduleStreakReminder accepts zero streak', () async {
      await NotificationService.instance.scheduleStreakReminder(0);
    });
  });
}
