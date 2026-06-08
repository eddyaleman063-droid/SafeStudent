import '../services/auth_service.dart';

abstract class AuthRepository {
  AppUser? get currentUser;
  bool get isLoggedIn;
  Future<void> init();
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithEmail({required String email, required String password});
  Future<AppUser> signUpWithEmail({required String email, required String password, required String displayName});
  Future<void> sendEmailVerification();
  Future<bool> reloadUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<void> deleteAccount();
  Stream<AppUser?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  AuthRepositoryImpl(this._authService);

  @override
  AppUser? get currentUser => _authService.currentUser;

  @override
  bool get isLoggedIn => _authService.isLoggedIn;

  @override
  Future<void> init() => _authService.init();

  @override
  Future<AppUser> signInWithGoogle() => _authService.signInWithGoogle();

  @override
  Future<AppUser> signInWithEmail({required String email, required String password}) =>
      _authService.signInWithEmail(email: email, password: password);

  @override
  Future<AppUser> signUpWithEmail({required String email, required String password, required String displayName}) =>
      _authService.signUpWithEmail(email: email, password: password, displayName: displayName);

  @override
  Future<void> sendEmailVerification() => _authService.sendEmailVerification();

  @override
  Future<bool> reloadUser() => _authService.reloadUser();

  @override
  Future<void> sendPasswordResetEmail(String email) => _authService.sendPasswordResetEmail(email);

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<void> deleteAccount() => _authService.deleteAccount();

  @override
  Stream<AppUser?> get authStateChanges => _authService.authStateChanges;
}
