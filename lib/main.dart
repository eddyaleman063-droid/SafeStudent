import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'core/theme/theme_constants.dart';
import 'l10n/app_localizations.dart';
import 'providers/providers.dart';
import 'router/app_router.dart';
import 'firebase_options.dart';
import 'services/analytics_service.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'services/cloud_sync_service.dart';
import 'services/admob_service.dart';
import 'services/sync_queue_service.dart';
import 'services/api_client.dart';
import 'services/app_logger.dart';
import 'services/experience_service.dart';
import 'services/smart_cache.dart';
import 'services/device_tier.dart';
import 'services/notification_service.dart';
import 'ui/widgets/common/ambient_background.dart';
import 'ui/widgets/common/error_boundary.dart';
import 'ui/widgets/chest_listener.dart';
import 'services/deep_link_service.dart';
import 'services/app_lock_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final logger = AppLogger();
  logger.setProductionMode(kReleaseMode);

  // ── Global error handlers ──────────────────────────────────
  if (kReleaseMode) {
    try {
      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        logger.error('FlutterError: ${details.exception}', details.exception, details.stack);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        logger.error('PlatformDispatcher error', error, stack);
        return true;
      };
    } catch (_) {}
  } else {
    FlutterError.onError = (details) {
      logger.error('FlutterError: ${details.exception}', details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.error('PlatformDispatcher error', error, stack);
      return true;
    };
  }

  if (kReleaseMode) {
    ErrorWidget.builder = (details) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: PremiumColors.deepBackground,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_rounded, size: 48, color: PremiumColors.primary),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'SAGEN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Ocurri\u00f3 un error de optimizaci\u00f3n visual.\nRegresando de forma segura...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white54, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('onboarding_done') != true;
  if (isFirstLaunch) {
    await prefs.setBool('onboarding_done', true);
  }

  // Create shared service instances
  final authService = AuthService(logger: logger);
  final cloudSyncService = CloudSyncService(authService: authService, logger: logger);

  runApp(
    ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        authServiceProvider.overrideWithValue(authService),
        cloudSyncServiceProvider.overrideWithValue(cloudSyncService),
        loggerProvider.overrideWithValue(logger),
      ],
      child: const SagenApp(),
    ),
  );

  Future.microtask(() => _initDeferredServices(prefs, logger, authService, cloudSyncService));
}

Future<void> _initDeferredServices(SharedPreferences prefs, AppLogger logger, AuthService authService, CloudSyncService cloudSyncService) async {
  try { LowEndDeviceDetector.instance.init(); } catch (e) { logger.error('Tier detection failed', e); }

  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    firebaseInitialized = true;
    logger.info('Firebase initialized successfully');
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
      );
      logger.info('App Check activated');
    } catch (e) {
      logger.warning('App Check activation failed: $e');
    }
  } catch (e) {
    logger.info('Firebase init failed: $e');
    try {
      await Future.delayed(const Duration(seconds: 2));
      const channel = MethodChannel('dev.sagen.app/firebase');
      await channel.invokeMethod('recoverFirebaseApp', {
        'appId': DefaultFirebaseOptions.android.appId,
        'apiKey': DefaultFirebaseOptions.android.apiKey,
        'projectId': DefaultFirebaseOptions.android.projectId,
        'storageBucket': DefaultFirebaseOptions.android.storageBucket,
        'messagingSenderId': DefaultFirebaseOptions.android.messagingSenderId,
        'databaseURL': DefaultFirebaseOptions.android.databaseURL,
      });
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
      firebaseInitialized = true;
      logger.info('Firebase recovered and initialized successfully');
    } catch (e2) { logger.error('Firebase initialization failed: $e2'); }
  }

  if (firebaseInitialized) {
    try { FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true); } catch (e) { logger.error('Firestore settings failed', e); }
    try { FirebaseAnalytics.instance; } catch (e) { logger.error('Analytics init failed', e); }
    logger.setCrashReporter((Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    });
    if (kReleaseMode) {
      try {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      } catch (e) { logger.error('Crashlytics init failed', e); }
    }
  }

  try { await authService.init(); logger.info('AuthService initialized'); } catch (e) { logger.error('Auth init failed', e); }
  try { await cloudSyncService.init(prefs); } catch (e) { logger.error('CloudSync init failed', e); }
  try { await SyncQueueService.instance.init(prefs); } catch (e) { logger.error('SyncQueue init failed', e); }
  try { await ApiClient.init(); } catch (e) { logger.error('ApiClient init failed', e); }
  try { await AnalyticsService.instance.init(); } catch (e) { logger.error('Analytics init failed', e); }
  try { ConnectivityService.instance.start(); } catch (e) { logger.error('Connectivity start failed', e); }
  try { await ExperienceService.instance.init(); } catch (e) { logger.error('Experience init failed', e); }
  try { await SmartCache.init(prefs); } catch (e) { logger.error('SmartCache init failed', e); }
  try {
    await NotificationService.instance.init();
    await NotificationService.instance.scheduleChestReminder();
  } catch (e) { logger.error('NotificationService init failed', e); }
  try { await AdMobService.instance.init(); } catch (e) { logger.error('AdMob init failed', e); }
  try { await DeepLinkService.instance.init(); } catch (e) { logger.error('DeepLinkService init failed', e); }
  try { await AppLockService.instance.handleAppStart(); } catch (e) { logger.error('AppLock init failed', e); }
}

class SagenApp extends ConsumerStatefulWidget {
  const SagenApp({super.key});

  @override
  ConsumerState<SagenApp> createState() => _SagenAppState();
}

class _SagenAppState extends ConsumerState<SagenApp> with WidgetsBindingObserver {
  StreamSubscription<DeepLinkAction>? _deepLinkSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _deepLinkSub = DeepLinkService.instance.actionStream.listen(_handleDeepLinkAction);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkSub?.cancel();
    ConnectivityService.instance.dispose();
    super.dispose();
  }

  void _handleDeepLinkAction(DeepLinkAction action) {
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) return;
    final router = ref.read(routerProvider);

    switch (action) {
      case ProfileDeepLink(:final uid):
        router.goNamed('profile', pathParameters: {'uid': uid});
      case RankingDeepLink():
        router.goNamed('main');
        DeepLinkService.instance.requestTabSwitch(3);
      case LessonDeepLink():
        router.goNamed('lessons');
      case UnknownDeepLink():
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ConnectivityService.instance.stop();
      _syncToCloud();
    } else if (state == AppLifecycleState.resumed) {
      ConnectivityService.instance.start();
      if (mounted) {
        ref.read(authProvider.notifier).refreshCurrentUser();
      }
    }
  }

  Future<void> _syncToCloud() async {
    try {
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (!auth.isAuthenticated) return;
      final prefs = ref.read(prefsProvider);
      final cloudSync = ref.read(cloudSyncServiceProvider);
      final authService = ref.read(authServiceProvider);
      final uid = authService.currentUser?.uid;
      if (uid != null) {
        await cloudSync.saveAll(uid, prefs);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final lang = ref.watch(languageProvider);
    final router = ref.watch(routerProvider);

    return ErrorBoundary(
      child: SyncCoordinator(
        child: AmbientBackground(
            child: MaterialApp.router(
            builder: (context, child) => ChestListener(child: child!),
            title: 'SAGEN',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: theme.currentTheme,
            key: ValueKey(lang.locale.languageCode),
            locale: lang.hasUserChosen ? lang.locale : null,
            supportedLocales: const [
              Locale('es'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supported) {
              if (locale != null) {
                for (final supportedLocale in supported) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              return supported.first;
            },
          ),
        ),
      ),
    );
  }
}


class SyncCoordinator extends ConsumerStatefulWidget {
  final Widget child;
  const SyncCoordinator({super.key, required this.child});

  @override
  ConsumerState<SyncCoordinator> createState() => _SyncCoordinatorState();
}

class _SyncCoordinatorState extends ConsumerState<SyncCoordinator> {
  @override
  void initState() {
    super.initState();
    ref.listen(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          try { ref.read(streakProvider.notifier).reload(); } catch (_) {}
          try { ref.read(learningProvider.notifier).reload(); } catch (_) {}
          try { ref.read(protectionProvider.notifier).reload(); } catch (_) {}
          try { ref.read(missionProvider.notifier).reload(); } catch (_) {}
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
