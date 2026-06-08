import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/services/admob_service.dart';

void main() {
  group('AdMobService', () {
    test('is a singleton', () {
      final a = AdMobService.instance;
      final b = AdMobService.instance;
      expect(a, same(b));
    });

    test('initial state has no ad loaded', () {
      final service = AdMobService.instance;
      expect(service.isAdReady, false);
      expect(service.isLoading, false);
      expect(service.isInitialized, false);
    });

    test('dispose clears ad state', () {
      final service = AdMobService.instance;
      service.dispose();
      expect(service.isAdReady, false);
      expect(service.isLoading, false);
    });

    test('showAd returns false when no ad loaded', () {
      final service = AdMobService.instance;
      final result = service.showAd(onUserEarnedReward: () {});
      expect(result, false);
    });
  });
}
