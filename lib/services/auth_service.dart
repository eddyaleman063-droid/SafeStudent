import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
export 'auth_models.dart';
import 'auth_models.dart';
import 'firebase_auth_client.dart';
import 'auth_session_manager.dart';
import 'app_logger.dart';

class AuthService {
  AuthService({AppLogger? logger}) : _logger = logger ?? AppLogger();

  final FirebaseAuthClient _client = FirebaseAuthClient();
  final AuthSessionManager _sessionManager = AuthSessionManager();
  final AppLogger _logger;

  AppUser? _currentUser;
  StreamSubscription<firebase.User?>? _authSub;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String get displayName => _currentUser?.displayName ?? 'Estudiante';
  String get email => _currentUser?.email ?? '';
  String? get photoUrl => _currentUser?.photoUrl;

  Stream<AppUser?> get authStateChanges {
    if (!_client.isAvailable) return const Stream.empty();
    return _client.authStateChanges.map((fbUser) {
      if (fbUser == null) return null;
      return _client.appUserFromFirebase(fbUser);
    });
  }

  Future<void> init() async {
    _authSub?.cancel();
    _client.init();

    if (!_client.isAvailable) return;

    _authSub = _client.authStateChanges.listen(
      (firebaseUser) async {
        try {
          if (firebaseUser != null) {
            await firebaseUser.reload();
            _currentUser = _client.appUserFromFirebase(firebaseUser);
            await _sessionManager.saveSession(_currentUser!);
          } else {
            _currentUser = null;
          }
        } catch (e) {
          _logger.error('AuthService: authState handler error', e);
        }
      },
      onError: (Object error) {
        _logger.error('AuthService: authStateChanges error', error);
      },
      cancelOnError: false,
    );

    try {
      final fbUser = _client.firebaseUser;
      if (fbUser != null) {
        await fbUser.reload();
        _currentUser = _client.appUserFromFirebase(fbUser);
        await _sessionManager.saveSession(_currentUser!);
      } else {
        _currentUser = await _sessionManager.restoreSession();
      }
    } catch (_) {
      _currentUser = await _sessionManager.restoreSession();
    }
  }

  Future<AppUser> signInWithGoogle() async {
    final user = await _client.signInWithGoogle();
    _currentUser = user;
    await _sessionManager.saveSession(user);
    return user;
  }

  Future<AppUser> signInWithFacebook() async {
    final user = await _client.signInWithFacebook();
    _currentUser = user;
    await _sessionManager.saveSession(user);
    return user;
  }

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await _client.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    _currentUser = user;
    await _sessionManager.saveSession(user);
    return user;
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await _client.signInWithEmail(email: email, password: password);
    _currentUser = user;
    await _sessionManager.saveSession(user);
    return user;
  }

  Future<void> sendEmailVerification() => _client.sendEmailVerification();

  Future<bool> reloadUser() async {
    final verified = await _client.reloadUser();
    final fbUser = _client.firebaseUser;
    if (fbUser != null) {
      _currentUser = _client.appUserFromFirebase(fbUser);
      await _sessionManager.saveSession(_currentUser!);
    }
    return verified;
  }

  Future<void> sendPasswordResetEmail(String email) =>
      _client.sendPasswordResetEmail(email);

  Future<void> signOut() async {
    await _client.signOutFirebase();
    await _sessionManager.clearSession();
    _currentUser = null;
  }

  Future<void> deleteAccount() async {
    await _client.deleteFirebaseUser();
    await signOut();
  }

  void dispose() {
    _authSub?.cancel();
  }
}
