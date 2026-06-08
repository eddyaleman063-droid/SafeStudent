class JsonUtils {
  JsonUtils._();

  static Map<String, dynamic> safeMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static List<dynamic> safeList(dynamic value) {
    if (value is List) return List<dynamic>.from(value);
    return <dynamic>[];
  }

  static String safeString(dynamic value, [String defaultValue = '']) {
    if (value is String) return value;
    if (value is int || value is double) return value.toString();
    if (value is bool) return value.toString();
    return defaultValue;
  }

  static int safeInt(dynamic value, [int defaultValue = 0]) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static double safeDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool safeBool(dynamic value, [bool defaultValue = false]) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return defaultValue;
  }

  static List<String> safeStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => safeString(e)).toList();
    }
    return <String>[];
  }

  static List<int> safeIntList(dynamic value) {
    if (value is List) {
      return value.map((e) => safeInt(e)).toList();
    }
    return <int>[];
  }

  static List<Map<String, dynamic>> safeMapList(dynamic value) {
    if (value is List) {
      return value.map((e) => safeMap(e)).toList();
    }
    return <Map<String, dynamic>>[];
  }
}
