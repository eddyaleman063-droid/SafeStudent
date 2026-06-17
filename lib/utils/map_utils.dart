Map<String, int> parseStringMap(String raw) {
  final map = <String, int>{};
  if (raw.isEmpty) return map;
  for (final entry in raw.split(',')) {
    final parts = entry.split(':');
    if (parts.length == 2) {
      map[parts[0]] = int.tryParse(parts[1]) ?? 0;
    }
  }
  return map;
}

String encodeStringMap(Map<String, int> map) {
  return map.entries.map((e) => '${e.key}:${e.value}').join(',');
}
