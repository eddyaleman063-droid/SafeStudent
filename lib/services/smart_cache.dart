import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheEntry<T> {
  final T data;
  final DateTime cachedAt;
  final Duration ttl;

  bool get isExpired => DateTime.now().difference(cachedAt) > ttl;

  CacheEntry({required this.data, required this.cachedAt, required this.ttl});

  Map<String, dynamic> toJson() => {
    'data': data is String ? data : jsonEncode(data),
    'cachedAt': cachedAt.toIso8601String(),
    'ttlMs': ttl.inMilliseconds,
  };

  factory CacheEntry.fromJson(Map<String, dynamic> json, T Function(dynamic) fromData) {
    final ttl = Duration(milliseconds: json['ttlMs'] as int? ?? 300000);
    return CacheEntry(
      data: fromData(json['data']),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      ttl: ttl,
    );
  }
}

class _NoOpCache extends SmartCache {
  _NoOpCache() : super._(null);

  @override
  T? get<T>(String key, T Function(dynamic) fromData) => null;

  @override
  Future<void> set<T>(String key, T data, {Duration ttl = const Duration(minutes: 5)}) async {}

  @override
  Future<void> invalidate(String key) async {}

  @override
  Future<void> invalidateAll() async {}
}

class SmartCache {
  static SmartCache? _instance;
  static SmartCache get instance => _instance ?? _NoOpCache();
  static bool get isInitialized => _instance != null;

  final SharedPreferences? _prefs;
  final Map<String, CacheEntry> _memory = {};
  static const _prefix = 'smart_cache_';
  static const int _maxMemoryEntries = 100;

  SmartCache._(this._prefs);

  static Future<void> init(SharedPreferences prefs) async {
    _instance = SmartCache._(prefs);
  }

  T? get<T>(String key, T Function(dynamic) fromData) {
    final mem = _memory[key];
    if (mem != null) {
      try {
        if (!mem.isExpired) return fromData(mem.data);
      } catch (_) {}
      _memory.remove(key);
    }
    final raw = _prefs?.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>, fromData);
      if (entry.isExpired) {
        _prefs?.remove('$_prefix$key');
        return null;
      }
      _memory[key] = entry;
      return entry.data;
    } catch (_) {
      return null;
    }
  }

  static const int _maxPrefsEntries = 200;
  static int _prefsWriteCount = 0;

  Future<void> set<T>(String key, T data, {Duration ttl = const Duration(minutes: 5)}) async {
    final entry = CacheEntry(data: data, cachedAt: DateTime.now(), ttl: ttl);
    _memory[key] = entry;
    if (_memory.length > _maxMemoryEntries) {
      final oldest = _memory.entries
          .where((e) => e.key != key)
          .fold<MapEntry<String, CacheEntry>?>(null, (prev, e) =>
              prev == null || e.value.cachedAt.isBefore(prev.value.cachedAt) ? e : prev);
      if (oldest != null) _memory.remove(oldest.key);
    }
    await _prefs?.setString('$_prefix$key', jsonEncode(entry.toJson()));
    _prefsWriteCount++;
    if (_prefsWriteCount % 50 == 0) {
      await _evictExpiredPrefs();
    }
  }

  Future<void> _evictExpiredPrefs() async {
    if (_prefs == null) return;
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final k in keys) {
      final raw = _prefs.getString(k);
      if (raw == null) continue;
      try {
        final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>, (d) => d);
        if (entry.isExpired) {
          await _prefs.remove(k);
        }
      } catch (_) {
        await _prefs.remove(k);
      }
    }
    final remaining = _prefs.getKeys().where((k) => k.startsWith(_prefix)).length;
    if (remaining > _maxPrefsEntries) {
      final allKeys = _prefs.getKeys().where((k) => k.startsWith(_prefix)).toList()
        ..sort((a, b) => (_prefs.getString(a) ?? '').compareTo(_prefs.getString(b) ?? ''));
      final toRemove = allKeys.take(remaining - _maxPrefsEntries);
      for (final k in toRemove) {
        await _prefs.remove(k);
      }
    }
  }

  Future<void> invalidate(String key) async {
    _memory.remove(key);
    await _prefs?.remove('$_prefix$key');
  }

  Future<void> invalidateAll() async {
    _memory.clear();
    if (_prefs == null) return;
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }

  static String Function(dynamic) stringData = (d) => d is String ? d : d?.toString() ?? '';
  static int Function(dynamic) intData = (d) => d is int ? d : int.tryParse(d.toString()) ?? 0;
  static double Function(dynamic) doubleData = (d) => d is double ? d : double.tryParse(d.toString()) ?? 0.0;
  static List<String> Function(dynamic) stringListData = (d) => d is List ? (d).map((e) => e.toString()).toList() : [];
}
