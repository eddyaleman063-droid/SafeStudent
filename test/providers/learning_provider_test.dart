import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/auth_service.dart';
import 'package:sagen/services/cloud_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCloudSyncService extends Mock implements CloudSyncService {}
class MockAuthService extends Mock implements AuthService {}

void main() {
  group('LearningNotifier - Gems', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
        cloudSyncServiceProvider.overrideWith((ref) => MockCloudSyncService()),
        authServiceProvider.overrideWith((ref) => MockAuthService()),
      ]);
    });

    tearDown(() => container.dispose());

    test('initial gems is 0', () {
      final notifier = container.read(learningProvider.notifier);
      expect(notifier.state.gems, 0);
    });

    test('addGems increases balance and totalGemsEarned', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(10);
      expect(notifier.state.gems, 10);
      expect(notifier.state.totalGemsEarned, 10);
    });

    test('addGems accumulates correctly across multiple calls', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(5);
      notifier.addGems(15);
      notifier.addGems(3);
      expect(notifier.state.gems, 23);
      expect(notifier.state.totalGemsEarned, 23);
    });

    test('spendGems returns true when sufficient', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(20);
      expect(notifier.spendGems(15), isTrue);
      expect(notifier.state.gems, 5);
    });

    test('spendGems returns false when insufficient', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(10);
      expect(notifier.spendGems(20), isFalse);
      expect(notifier.state.gems, 10);
    });

    test('spendGems with exact balance returns true and depletes', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(50);
      expect(notifier.spendGems(50), isTrue);
      expect(notifier.state.gems, 0);
    });

    test('spendGems does not change totalGemsEarned', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(100);
      expect(notifier.state.totalGemsEarned, 100);
      notifier.spendGems(30);
      expect(notifier.state.gems, 70);
      expect(notifier.state.totalGemsEarned, 100);
    });

    test('spendGems with 0 gems returns false', () {
      final notifier = container.read(learningProvider.notifier);
      expect(notifier.spendGems(1), isFalse);
      expect(notifier.state.gems, 0);
    });

    test('addGems with 0 is a no-op', () {
      final notifier = container.read(learningProvider.notifier);
      notifier.addGems(0);
      expect(notifier.state.gems, 0);
      expect(notifier.state.totalGemsEarned, 0);
    });
  });
}
