import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_logger.dart';

class AdManagerService {
  AdManagerService._() : _logger = AppLogger();
  final AppLogger _logger;
  static final AdManagerService instance = AdManagerService._();

  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get isAdAvailable => _rewardedAd != null && !_isLoading;

  /// Initialize AdMob. Call once at app startup.
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      _logger.info('AdMob initialized');
    } catch (e) {
      _logger.error('AdMob init failed', e);
    }
  }

  /// Load a rewarded video ad
  void loadRewardedAd() {
    if (_isLoading || !_isInitialized) return;
    _isLoading = true;

    _rewardedAd?.dispose();
    _rewardedAd = null;

    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ID — reemplazar al publicar
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _isLoading = false;
              _schedulePreload();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isLoading = false;
              _logger.error('Rewarded ad failed to show', error);
            },
          );
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _logger.error('Failed to load rewarded ad', error);
          _isLoading = false;
        },
      ),
    );
  }

  /// Show the rewarded ad. `onReward` is called when user earns the reward.
  void showRewardedAd({required VoidCallback onReward}) {
    final ad = _rewardedAd;
    if (ad == null) {
      loadRewardedAd();
      return;
    }

    ad.show(
      onUserEarnedReward: (ad, reward) {
        onReward();
      },
    );
  }

  void _schedulePreload() {
    Future.delayed(const Duration(seconds: 5), loadRewardedAd);
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
