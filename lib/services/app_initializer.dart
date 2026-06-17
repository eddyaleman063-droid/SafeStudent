import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_manager_service.dart';
import 'analytics_service.dart';
import 'api_client.dart';
import 'app_logger.dart';
import 'auth_service.dart';
import 'cloud_sync_service.dart';
import 'connectivity_service.dart';
import 'content_loader.dart';
import 'deep_link_service.dart';
import 'device_tier.dart';
import 'experience_service.dart';
import 'notification_service.dart';
import 'smart_cache.dart';
import 'sync_queue_service.dart';

class AppInitializer {
  static Future<void> initDeferredServices(
    SharedPreferences prefs,
    AppLogger logger,
    AuthService authService,
    CloudSyncService cloudSyncService,
    void Function() onConnectivityChanged,
  ) async {
    try {
      LowEndDeviceDetector.instance.init();
    } catch (e) {
      logger.error('Tier detection failed', e);
    }

    try {
      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: true);
    } catch (e) {
      logger.error('Firestore settings failed', e);
    }
    try {
      FirebaseAnalytics.instance;
    } catch (e) {
      logger.error('Analytics init failed', e);
    }
    logger.setCrashReporter((Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    });

    try {
      await authService.init();
      logger.info('AuthService initialized');
    } catch (e) {
      logger.error('Auth init failed', e);
    }
    try {
      await cloudSyncService.init(prefs);
    } catch (e) {
      logger.error('CloudSync init failed', e);
    }
    try {
      await SyncQueueService.instance.init(prefs);
    } catch (e) {
      logger.error('SyncQueue init failed', e);
    }
    try {
      await ApiClient.init();
    } catch (e) {
      logger.error('ApiClient init failed', e);
    }
    try {
      await AnalyticsService.instance.init();
    } catch (e) {
      logger.error('Analytics init failed', e);
    }
    try {
      ConnectivityService.instance.start();
      ConnectivityService.instance.online.addListener(onConnectivityChanged);
    } catch (e) {
      logger.error('Connectivity start failed', e);
    }
    try {
      await ExperienceService.instance.init();
    } catch (e) {
      logger.error('Experience init failed', e);
    }
    try {
      await SmartCache.init(prefs);
    } catch (e) {
      logger.error('SmartCache init failed', e);
    }
    try {
      await NotificationService.instance.init();
      await NotificationService.instance.scheduleChestReminder();
    } catch (e) {
      logger.error('NotificationService init failed', e);
    }
    try {
      await AdManagerService.instance.init();
    } catch (e) {
      logger.error('AdMob init failed', e);
    }
    try {
      await DeepLinkService.instance.init();
    } catch (e) {
      logger.error('DeepLinkService init failed', e);
    }
    try {
      // Quotes are built-in, no load needed
    } catch (e) {
      logger.error('Quotes init failed', e);
    }
    try {
      await ContentLoader.instance.load();
    } catch (e) {
      logger.error('ContentLoader init failed', e);
    }
  }
}
