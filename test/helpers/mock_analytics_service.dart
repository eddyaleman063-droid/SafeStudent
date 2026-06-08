class MockAnalyticsService {
  final List<String> trackedEvents = [];
  final List<String> trackedFeatures = [];
  String? lastAdRewardSource;
  String? lastFlexCardSource;

  Future<void> init() async {}

  void track(String event, {Map<String, dynamic>? properties}) {
    trackedEvents.add(event);
  }

  void trackAdRewardClaimed() {
    trackedFeatures.add('ad_reward');
  }

  void trackFlexCardShared(String source) {
    trackedFeatures.add('flex_card_shared');
    lastFlexCardSource = source;
  }

  void trackScreen(String screenName) {
    trackedEvents.add('screen_view_$screenName');
  }

  void trackFeatureUsed(String feature) {
    trackedFeatures.add(feature);
  }

  void reset() {
    trackedEvents.clear();
    trackedFeatures.clear();
    lastAdRewardSource = null;
    lastFlexCardSource = null;
  }
}
