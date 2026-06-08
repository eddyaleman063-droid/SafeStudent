import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_logger.dart';

class SecureStorageService {
  static final SecureStorageService instance = SecureStorageService._();
  SecureStorageService._() : _logger = AppLogger();
  final AppLogger _logger;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyPrefix = 'ss_';

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: '$_keyPrefix$key', value: value);
    } catch (e) {
      _logger.warning('SecureStorage: write failed for $key — $e');
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: '$_keyPrefix$key');
    } catch (e) {
      _logger.warning('SecureStorage: read failed for $key — $e');
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: '$_keyPrefix$key');
    } catch (e) {
      _logger.warning('SecureStorage: delete failed for $key — $e');
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      _logger.warning('SecureStorage: deleteAll failed — $e');
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: '$_keyPrefix$key');
    } catch (e) {
      _logger.warning('SecureStorage: containsKey failed for $key — $e');
      return false;
    }
  }
}
