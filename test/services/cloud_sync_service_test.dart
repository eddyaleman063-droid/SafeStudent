import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sagen/services/auth_service.dart';
import 'package:sagen/services/cloud_sync_service.dart';

void main() {
  group('CloudSyncService', () {
    late CloudSyncService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      service = CloudSyncService(authService: AuthService());
      await service.init(prefs);
    });
    test('initializes with no last sync', () {
      expect(service.isInitialized, true);
      expect(service.lastSync, isNull);
      expect(service.isSyncing, false);
    });
    test('syncProfile returns false when not syncing (no user)', () async {
      final result = await service.syncProfile();
      expect(result, false);
    });
    test('syncProgress returns null when not syncing (no user)', () async {
      final result = await service.syncProgress();
      expect(result, isNull);
    });
    test('syncMissions returns false when not syncing (no user)', () async {
      final result = await service.syncMissions();
      expect(result, false);
    });
    test('restoreProfile returns null when not syncing (no user)', () async {
      final result = await service.restoreProfile();
      expect(result, isNull);
    });
    test('restoreProgress returns null when not syncing (no user)', () async {
      final result = await service.restoreProgress();
      expect(result, isNull);
    });
    test('deleteCloudData returns false when not syncing (no user)', () async {
      final result = await service.deleteCloudData(
        'test-uid',
      );
      expect(result, false);
    });
    test('gracefully handles double init', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await service.init(prefs);
      expect(service.isInitialized, true);
    });
  });
}
