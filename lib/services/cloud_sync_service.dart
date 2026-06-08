import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logger.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class CloudSyncService {
  CloudSyncService({required AuthService authService, AppLogger? logger})
    : _authService = authService,
      _logger = logger ?? AppLogger();

  final AuthService _authService;
  final AppLogger _logger;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  DateTime? _lastSync;
  DateTime? get lastSync => _lastSync;
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  StreamSubscription<DocumentSnapshot>? _snapshotSub;
  String? _listeningUid;

  static const _lastSyncKey = 'cloud_last_sync';

  void Function(String spKey, dynamic value)? onFieldChanged;

  static const Map<String, String> _spToFirestore = {
    'learning_gems': 'gemsBalance',
    'learning_xp': 'totalXp',
    'learning_total_gems': 'gemsBalance',
    'learning_total_xp': 'totalXp',
    'learning_level': 'level',
    'learning_lessons_completed': 'lessonsCompleted',
    'streak_current': 'currentStreak',
    'streak_longest': 'longestStreak',
  };

  void notifyFieldChanged(String spKey, dynamic value) {
    if (value is! int) return;
    final firestoreField = _spToFirestore[spKey];
    if (firestoreField == null) return;
    final uid = _currentUid();
    if (uid == null) return;
    FirestoreService.instance
        .updateField(uid, firestoreField, value)
        .catchError((_) {});
  }

  String? _currentUid() {
    try {
      return _authService.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  void startListening(String uid, SharedPreferences prefs) {
    if (_listeningUid == uid) return;
    _snapshotSub?.cancel();
    _listeningUid = uid;
    _snapshotSub = _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (snapshot) => _onSnapshot(snapshot, prefs),
          onError: (e) =>
              _logger.error('CloudSync: snapshot error: $e'),
        );
    _logger.info('CloudSync: listening to user $uid');
  }

  void stopListening() {
    _snapshotSub?.cancel();
    _snapshotSub = null;
    _listeningUid = null;
  }

  void _onSnapshot(DocumentSnapshot snapshot, SharedPreferences prefs) {
    if (!snapshot.exists) return;
    try {
      _applyDocumentData(snapshot.data() as Map<String, dynamic>, prefs);
    } catch (e) {
      _logger.error('CloudSync: _onSnapshot error: $e');
    }
  }

  Future<void> _applyDocumentData(
      Map<String, dynamic> data, SharedPreferences prefs) async {
    for (final entry in data.entries) {
      if (entry.key.startsWith('_')) continue;
      try {
        final val = entry.value;
        if (val is String) {
          await prefs.setString(entry.key, val);
        } else if (val is int) {
          await prefs.setInt(entry.key, val);
        } else if (val is bool) {
          await prefs.setBool(entry.key, val);
        } else if (val is double) {
          await prefs.setDouble(entry.key, val);
        } else if (val is List) {
          await prefs.setString(entry.key, jsonEncode(val));
        } else if (val is Map) {
          await prefs.setString(entry.key, jsonEncode(val));
        }
      } catch (_) {}
    }
  }

  @pragma('vm:entry-point')
  Future<void> init(SharedPreferences prefs) async {
    if (_initialized) return;
    _initialized = true;

    final lastSyncStr = prefs.getString(_lastSyncKey);
    if (lastSyncStr != null) {
      _lastSync = DateTime.tryParse(lastSyncStr);
    }

    _logger.info('CloudSync: initialized');
  }

  static const List<String> _keysToSync = [
    // Streak
    'streak_current', 'streak_longest', 'streak_last_activity',
    'streak_freezes', 'streak_total_checkins', 'streak_perfect_weeks',
    'streak_history', 'streak_weekly_stats', 'streak_heatmap',
    'streak_monthly_data',
    // Learning
    'learning_xp', 'learning_level', 'learning_gems',
    'learning_lessons_completed', 'learning_total_xp', 'learning_total_gems',
    'learning_stages', 'learning_achievements',
    // Protection
    'protection_score', 'protection_queries', 'protection_analyses',
    'protection_missions', 'protection_checkins',
    'protection_topics', 'protection_habits',
    // Missions
    'daily_missions_v2', 'daily_missions_reset', 'daily_missions_total',
    // Learning memory
    'learning_memory_weak_topics', 'learning_memory_completed_challenges',
    'learning_memory_failed', 'learning_memory_passed',
    'learning_memory_last_session', 'learning_memory_sessions_week',
    // Achievements
    'achievements_data',
    // Shop
    'shop_streak_shields', 'shop_xp_boost', 'shop_owned_items',
    // Daily challenges
    'daily_challenges',
  ];

  Future<bool> saveAll(String uid, SharedPreferences prefs) async {
    if (!_initialized) return false;

    try {
      _isSyncing = true;
      final data = <String, dynamic>{};
      for (final key in _keysToSync) {
        final val = _getPrefValue(prefs, key);
        if (val != null) data[key] = val;
      }
      data['_last_sync'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
      _lastSync = DateTime.now();
      _logger.info('CloudSync: saved ${data.length} keys for $uid');
      return true;
    } catch (e) {
      _logger.error('CloudSync: saveAll failed: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> loadAll(String uid, SharedPreferences prefs) async {
    if (!_initialized) return false;

    try {
      _isSyncing = true;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        _logger.info('CloudSync: no cloud data for $uid');
        return false;
      }

      final data = doc.data()!;
      await _applyDocumentData(data, prefs);
      _logger.info('CloudSync: loaded ${data.length} keys for $uid');
      return true;
    } catch (e) {
      _logger.error('CloudSync: loadAll failed: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> clearLocal(SharedPreferences prefs) async {
    int count = 0;
    for (final key in _keysToSync) {
      final removed = await prefs.remove(key);
      if (removed) count++;
    }
    _logger.info('CloudSync: cleared $count local keys');
  }

  Future<bool> deleteCloudData(String uid) async {
    if (!_initialized) return false;
    try {
      await _firestore.collection('users').doc(uid).delete();
      _logger.info('CloudSync: deleted cloud data for $uid');
      return true;
    } catch (e) {
      _logger.error('CloudSync: deleteCloudData failed: $e');
      return false;
    }
  }

  // ── Private helpers ──

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  dynamic _getPrefValue(SharedPreferences prefs, String key) {
    final val = prefs.get(key);
    if (val == null) return null;
    if (val is String || val is int || val is bool || val is double) return val;
    if (val is List) return val;
    return null;
  }

  // Legacy stub-compatible methods

  Future<bool> syncProfile() async {
    _logger.info('CloudSync: syncProfile not used (use saveAll)');
    return false;
  }

  Future<Map<String, dynamic>?> syncProgress() async {
    _logger.info('CloudSync: syncProgress not used (use saveAll)');
    return null;
  }

  Future<bool> syncMissions() async {
    _logger.info('CloudSync: syncMissions not used (use saveAll)');
    return false;
  }

  Future<Map<String, dynamic>?> restoreProfile() async {
    _logger.info('CloudSync: restoreProfile not used (use loadAll)');
    return null;
  }

  Future<Map<String, dynamic>?> restoreProgress() async {
    _logger.info('CloudSync: restoreProgress not used (use loadAll)');
    return null;
  }
}
