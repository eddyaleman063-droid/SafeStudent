import 'package:flutter/foundation.dart';

class MockAdMobService {
  bool _isAdReady = false;
  bool _showAdCalled = false;
  bool _initCalled = false;
  VoidCallback? _onRewardCallback;

  bool get isAdReady => _isAdReady;
  bool get showAdCalled => _showAdCalled;
  bool get initCalled => _initCalled;

  void setAdReady(bool value) => _isAdReady = value;

  Future<void> init() async {
    _initCalled = true;
  }

  bool showAd({VoidCallback? onUserEarnedReward}) {
    _showAdCalled = true;
    _onRewardCallback = onUserEarnedReward;
    if (!_isAdReady) return false;
    onUserEarnedReward?.call();
    return true;
  }

  void dispose() {
    _isAdReady = false;
    _showAdCalled = false;
    _onRewardCallback = null;
  }

  void reloadAd() {
    _isAdReady = false;
  }

  void simulateReward() {
    _onRewardCallback?.call();
  }
}
