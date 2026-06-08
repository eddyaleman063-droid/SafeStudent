import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_logger.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._();
  static AdMobService get instance => _instance;
  AdMobService._() : _logger = AppLogger();
  final AppLogger _logger;

  RewardedAd? _rewardedAd;
  bool _isInitialized = false;
  bool _isLoading = false;

  static const _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  bool get isAdReady => _rewardedAd != null;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      _logger.info('AdMob initialized');
      _loadAd();
    } catch (e) {
      _logger.error('AdMob init failed', e);
    }
  }

  void _loadAd() {
    if (_isLoading) return;
    _isLoading = true;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          _logger.info('RewardedAd loaded');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _rewardedAd = null;
              _loadAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _rewardedAd = null;
              _loadAd();
              _logger.error('RewardedAd failed to show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _logger.error('RewardedAd failed to load: $error');
          Future.delayed(const Duration(seconds: 30), _loadAd);
        },
      ),
    );
  }

  bool showAd({VoidCallback? onUserEarnedReward}) {
    final ad = _rewardedAd;
    if (ad == null) return false;
    _rewardedAd = null;
    ad.show(onUserEarnedReward: (ad, reward) {
      _logger.info('User earned reward: ${reward.amount} ${reward.type}');
      onUserEarnedReward?.call();
    });
    return true;
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoading = false;
  }

  void reloadAd() {
    dispose();
    _loadAd();
  }
}
