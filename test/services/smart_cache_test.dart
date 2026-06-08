import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sagen/services/smart_cache.dart';

void main() {
  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await SmartCache.init(prefs);
  });
  tearDown(() async {
    await SmartCache.instance.invalidateAll();
  });
  group('SmartCache', () {
    test('stores and retrieves string values', () async {
      await SmartCache.instance.set('test_key', 'hello');
      final result = SmartCache.instance.get<String>('test_key', SmartCache.stringData);
      expect(result, 'hello');
    });
    test('returns null for missing keys', () {
      final result = SmartCache.instance.get<String>('missing', SmartCache.stringData);
      expect(result, isNull);
    });
    test('respects TTL expiration', () async {
      await SmartCache.instance.set('expires_soon', 'data', ttl: const Duration(milliseconds: 1));
      await Future.delayed(const Duration(milliseconds: 10));
      final result = SmartCache.instance.get<String>('expires_soon', SmartCache.stringData);
      expect(result, isNull);
    });
    test('invalidates single key', () async {
      await SmartCache.instance.set('key_a', 'a');
      await SmartCache.instance.set('key_b', 'b');
      await SmartCache.instance.invalidate('key_a');
      expect(SmartCache.instance.get<String>('key_a', SmartCache.stringData), isNull);
      expect(SmartCache.instance.get<String>('key_b', SmartCache.stringData), 'b');
    });
    test('invalidates all keys', () async {
      await SmartCache.instance.set('k1', 'v1');
      await SmartCache.instance.set('k2', 'v2');
      await SmartCache.instance.invalidateAll();
      expect(SmartCache.instance.get<String>('k1', SmartCache.stringData), isNull);
      expect(SmartCache.instance.get<String>('k2', SmartCache.stringData), isNull);
    });
    test('stores and retrieves int values', () async {
      await SmartCache.instance.set('int_key', 42);
      final result = SmartCache.instance.get<int>('int_key', SmartCache.intData);
      expect(result, 42);
    });
    test('persists in SharedPreferences', () async {
      await SmartCache.instance.set('persist', 'stored');
      final raw = prefs.getString('smart_cache_persist');
      expect(raw, isNotNull);
      expect(raw, contains('stored'));
    });
  });
}
