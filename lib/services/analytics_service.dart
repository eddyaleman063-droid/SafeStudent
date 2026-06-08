import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

enum AnalyticEvent {
  appOpen,
  appClose,
  screenView,
  linkAnalysis,
  tutorQuery,
  voiceQuery,
  streakCheckIn,
  notificationRead,
  notificationClear,
  historySearch,
  historyDelete,
  settingsChange,
  challengeAttempt,
  challengeComplete,
  challengeFail,
  lessonComplete,
  onboardingStep,
  featureUsed,
  tutorialComplete,
  signUp,
  signIn,
  chestOpened,
}

enum Achievement {
  firstQuery('Primera consulta', 'Preguntaste algo a Sage por primera vez'),
  streak3('3 días seguidos', 'Mantuviste tu racha por 3 días'),
  streak7('7 días seguidos', 'Una semana completa de actividad'),
  streak14('14 días seguidos', 'Dos semanas imparable'),
  streak30('30 días seguidos', 'Un mes de aprendizaje continuo'),
  streak100('100 días seguidos', 'Maestro de la ciberseguridad'),
  tenQueries('10 consultas', 'Le preguntaste 10 cosas a Sage'),
  voiceFirst('Primera voz', 'Usaste el micrófono por primera vez'),
  linkFirst('Primer análisis', 'Analizaste tu primer enlace'),
  perfectWeek('Semana perfecta', 'Completaste 7 días sin fallar'),
  protectedMonth('Mes protegido', 'Mantuviste tu racha todo el mes'),
  cyberGuardian('Guardian Digital', 'Lograste 30+ días de racha'),
  shieldBasic('Escudo Inicial', 'Tu primer día de protección'),
  shieldGlow('Escudo Radiante', 'Llegaste a 7 días de racha'),
  shieldCrystal('Escudo de Cristal', 'Alcanzaste 30 días de racha'),
  shieldLegendary('Escudo Legendario', 'Lograste 100 días de racha'),
  firstLinkSafe('Enlace Seguro', 'Analizaste tu primer enlace seguro'),
  firstLinkDanger('Alerta Temprana', 'Detectaste tu primer enlace peligroso'),
  ;

  final String title;
  final String description;
  const Achievement(this.title, this.description);
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._();
  static AnalyticsService get instance => _instance;
  AnalyticsService._();

  static const _keyEvents = 'analytics_events';
  static const _keyAggregated = 'analytics_aggregated';
  static const _keyAchievements = 'analytics_achievements';
  static const _maxStoredEvents = 500;

  bool _initialized = false;
  SharedPreferences? _prefs;
  FirebaseAnalytics? _firebase;
  final List<Map<String, dynamic>> _eventLog = [];
  final Set<Achievement> _unlocked = {};
  Map<String, int> _aggregated = {};

  bool get isInitialized => _initialized;
  Set<Achievement> get unlocked => Set.unmodifiable(_unlocked);
  List<Achievement> get allAchievements => Achievement.values.toList();
  Map<String, int> get aggregated => Map.unmodifiable(_aggregated);

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _load();
    } catch (_) {}
    try {
      _firebase = FirebaseAnalytics.instance;
    } catch (_) {}
    _initialized = true;
  }

  void _load() {
    final eventsJson = _prefs?.getString(_keyEvents);
    if (eventsJson != null) {
      final list = jsonDecode(eventsJson) as List;
      _eventLog.addAll(list.cast<Map<String, dynamic>>());
      if (_eventLog.length > _maxStoredEvents) {
        _eventLog.removeRange(0, _eventLog.length - _maxStoredEvents);
      }
    }
    final aggJson = _prefs?.getString(_keyAggregated);
    if (aggJson != null) {
      final map = jsonDecode(aggJson) as Map<String, dynamic>;
      _aggregated = map.map((k, v) => MapEntry(k, v as int));
    }
    final achJson = _prefs?.getString(_keyAchievements);
    if (achJson != null) {
      final list = jsonDecode(achJson) as List;
      for (final item in list) {
        final a = Achievement.values.firstWhere(
          (a) => a.name == item,
          orElse: () => Achievement.firstQuery,
        );
        _unlocked.add(a);
      }
    }
  }

  void _save() {
    try {
      if (_eventLog.length > _maxStoredEvents) {
        final trimmed = _eventLog.sublist(_eventLog.length - _maxStoredEvents);
        _prefs?.setString(_keyEvents, jsonEncode(trimmed));
      } else {
        _prefs?.setString(_keyEvents, jsonEncode(_eventLog));
      }
      _prefs?.setString(_keyAggregated, jsonEncode(_aggregated));
      _prefs?.setString(
        _keyAchievements,
        jsonEncode(_unlocked.map((a) => a.name).toList()),
      );
    } catch (_) {}
  }

  void track(AnalyticEvent event, {Map<String, dynamic>? properties}) {
    if (!_initialized) return;
    final entry = <String, dynamic>{
      'event': event.name,
      'timestamp': DateTime.now().toIso8601String(),
    };
    if (properties != null) entry['properties'] = properties;
    _eventLog.add(entry);

    final key = 'count_${event.name}';
    _aggregated[key] = (_aggregated[key] ?? 0) + 1;

    if (properties != null) {
      for (final p in properties.entries) {
        final propKey = '${event.name}_${p.key}_${p.value}';
        _aggregated[propKey] = (_aggregated[propKey] ?? 0) + 1;
      }
    }

    _save();
    _logToFirebase(event, properties);
  }

  void _logToFirebase(AnalyticEvent event, Map<String, dynamic>? properties) {
    try {
      final fb = _firebase;
      if (fb == null) return;
      final name = _firebaseEventName(event);
      if (properties case final p?) {
        fb.logEvent(name: name, parameters: p.cast<String, Object>());
      } else {
        fb.logEvent(name: name);
      }
    } catch (_) {}
  }

  String _firebaseEventName(AnalyticEvent event) {
    switch (event) {
      case AnalyticEvent.screenView:
        return 'screen_view';
      case AnalyticEvent.lessonComplete:
        return 'lesson_completed';
      case AnalyticEvent.challengeComplete:
        return 'challenge_completed';
      case AnalyticEvent.challengeFail:
        return 'challenge_failed';
      case AnalyticEvent.streakCheckIn:
        return 'streak_checkin';
      case AnalyticEvent.tutorialComplete:
        return 'tutorial_complete';
      case AnalyticEvent.signUp:
        return 'sign_up';
      case AnalyticEvent.signIn:
        return 'login';
      case AnalyticEvent.chestOpened:
        return 'chest_opened';
      case AnalyticEvent.appOpen:
        return 'app_open';
      case AnalyticEvent.appClose:
        return 'app_close';
      default:
        return event.name;
    }
  }

  void trackScreen(String screenName) {
    track(AnalyticEvent.screenView, properties: {'screen': screenName});
  }

  void trackChallengeAttempt(String challengeId, bool correct) {
    track(
      correct ? AnalyticEvent.challengeComplete : AnalyticEvent.challengeFail,
      properties: {'challenge': challengeId},
    );
    track(AnalyticEvent.challengeAttempt, properties: {'challenge': challengeId});
  }

  void trackLessonComplete(String lessonId) {
    track(AnalyticEvent.lessonComplete, properties: {'lesson': lessonId});
  }

  void trackOnboardingStep(int step) {
    track(AnalyticEvent.onboardingStep, properties: {'step': step.toString()});
  }

  void trackOnboardingComplete() {
    track(AnalyticEvent.onboardingStep, properties: {'step': 'complete'});
  }

  void trackFeatureUsed(String feature) {
    track(AnalyticEvent.featureUsed, properties: {'feature': feature});
  }

  void trackAdRewardClaimed() {
    track(AnalyticEvent.featureUsed, properties: {'feature': 'ad_reward'});
  }

  void trackFlexCardShared(String source) {
    track(AnalyticEvent.featureUsed, properties: {
      'feature': 'flex_card_shared',
      'source': source,
    });
  }

  int eventCount(AnalyticEvent event) =>
      _aggregated['count_${event.name}'] ?? 0;

  int challengeAttempts(String challengeId) =>
      _aggregated['${AnalyticEvent.challengeAttempt.name}_challenge_$challengeId'] ?? 0;

  int challengeFails(String challengeId) =>
      _aggregated['${AnalyticEvent.challengeFail.name}_challenge_$challengeId'] ?? 0;

  double challengePassRate(String challengeId) {
    final total = challengeAttempts(challengeId);
    if (total == 0) return 0;
    final fails = challengeFails(challengeId);
    return (total - fails) / total;
  }

  bool isAchievementUnlocked(Achievement a) => _unlocked.contains(a);

  void unlockAchievement(Achievement achievement) {
    if (_unlocked.contains(achievement)) return;
    _unlocked.add(achievement);
    track(AnalyticEvent.appOpen, properties: {
      'achievement': achievement.name,
      'title': achievement.title,
    });
  }

  void remove(Achievement achievement) {
    _unlocked.remove(achievement);
    _save();
  }

  void clearAll() {
    _unlocked.clear();
    _eventLog.clear();
    _aggregated.clear();
    _save();
  }

  void save() {}
}
