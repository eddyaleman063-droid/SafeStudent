class MockNotificationService {
  int _cancelAllCalls = 0;
  int _scheduleStreakCalls = 0;
  int _scheduleChestCalls = 0;
  int _lastStreak = 0;

  int get cancelAllCalls => _cancelAllCalls;
  int get scheduleStreakCalls => _scheduleStreakCalls;
  int get scheduleChestCalls => _scheduleChestCalls;
  int get lastStreak => _lastStreak;

  Future<void> init() async {}

  Future<void> scheduleChestReminder() async {
    _scheduleChestCalls++;
  }

  Future<void> scheduleStreakReminder(int currentStreak) async {
    _scheduleStreakCalls++;
    _lastStreak = currentStreak;
  }

  Future<void> cancelStreakReminder() async {}

  Future<void> cancelAll() async {
    _cancelAllCalls++;
  }

  void reset() {
    _cancelAllCalls = 0;
    _scheduleStreakCalls = 0;
    _scheduleChestCalls = 0;
    _lastStreak = 0;
  }
}
