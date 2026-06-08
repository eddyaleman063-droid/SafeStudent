import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  String getString(String key, [String defaultValue = '']) =>
      _prefs.getString(key) ?? defaultValue;

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  int getInt(String key, [int defaultValue = 0]) =>
      _prefs.getInt(key) ?? defaultValue;

  Future<bool> setInt(String key, int value) =>
      _prefs.setInt(key, value);

  bool getBool(String key, [bool defaultValue = false]) =>
      _prefs.getBool(key) ?? defaultValue;

  Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  List<Map<String, dynamic>> getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw);
      if (list is List) return list.cast<Map<String, dynamic>>();
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> list) =>
      _prefs.setString(key, jsonEncode(list));

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return decoded.cast<String, dynamic>();
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  Future<bool> remove(String key) => _prefs.remove(key);
}
