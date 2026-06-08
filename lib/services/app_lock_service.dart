import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logger.dart';

class AppLockService {
  AppLockService._() : _logger = AppLogger();
  final AppLogger _logger;
  static final AppLockService instance = AppLockService._();

  final LocalAuthentication _auth = LocalAuthentication();
  static const _prefsKey = 'app_lock_enabled';

  bool _isLocked = false;
  bool get isLocked => _isLocked;

  Future<bool> get isAvailable async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (e) {
      _logger.info('AppLock: biometric check failed: $e');
      return false;
    }
  }

  Future<bool> get isEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  Future<bool> authenticate() async {
    if (!await isAvailable) return false;

    try {
      _isLocked = true;
      final result = await _auth.authenticate(
        localizedReason: 'Desbloquea SAGEN para continuar',
        biometricOnly: false,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: true,
      );
      _isLocked = !result;
      return result;
    } catch (e) {
      _logger.info('AppLock: auth failed: $e');
      _isLocked = false;
      return false;
    }
  }

  Future<bool> handleAppStart() async {
    if (!await isEnabled) return true;
    return authenticate();
  }
}
