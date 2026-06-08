import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';
import 'prefs_provider.dart';
import 'service_providers.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? uid;
  final bool pendingVerification;

  const AuthState({
    this.status = AuthStatus.uninitialized,
    this.errorMessage,
    this.displayName = '',
    this.email = '',
    this.photoUrl,
    this.uid,
    this.pendingVerification = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? Function()? errorMessage,
    String? displayName,
    String? email,
    String? Function()? photoUrl,
    String? Function()? uid,
    bool? pendingVerification,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl != null ? photoUrl() : this.photoUrl,
      uid: uid != null ? uid() : this.uid,
      pendingVerification: pendingVerification ?? this.pendingVerification,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isUninitialized => status == AuthStatus.uninitialized;
  bool get showVerificationScreen => pendingVerification;
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;
  late final CloudSyncService _cloudSync;
  SharedPreferences? _prefs;
  StreamSubscription<AppUser?>? _authSub;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    _cloudSync = ref.watch(cloudSyncServiceProvider);
    final prefs = ref.watch(prefsProvider);
    _prefs = prefs;
    _applyUser(_authService.currentUser);
    _authSub = _authService.authStateChanges.listen(_onAuthStateChanged, onError: (_) {});
    ref.onDispose(() {
      _authSub?.cancel();
    });
    return state;
  }

  void _onAuthStateChanged(AppUser? user) {
    final wasAuthenticated = state.status == AuthStatus.authenticated;
    _applyUser(user);
    if (state.status == AuthStatus.authenticated && !wasAuthenticated) {
      _syncAfterLogin(uid: user!.uid);
      if (_prefs != null) {
        _cloudSync.startListening(user.uid, _prefs!);
      }
    } else if (state.status == AuthStatus.unauthenticated && wasAuthenticated) {
      _cloudSync.stopListening();
    }
  }

  void _applyUser(AppUser? user) {
    if (user != null) {
      state = state.copyWith(
        displayName: user.displayName,
        email: user.email,
        photoUrl: () => user.photoUrl,
        uid: () => user.uid,
        pendingVerification: !user.isEmailVerified,
        status: user.isEmailVerified ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        errorMessage: () => null,
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> refreshCurrentUser() async {
    _applyUser(_authService.currentUser);
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: () => null);
    try {
      final user = await _authService.signInWithGoogle();
      state = state.copyWith(
        displayName: user.displayName,
        email: user.email,
        photoUrl: () => user.photoUrl,
        uid: () => user.uid,
        pendingVerification: !user.isEmailVerified,
        status: user.isEmailVerified ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        errorMessage: () => null,
      );
    } on AuthException catch (e) {
      if (e.code == 'canceled') {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: () => e.code,
        );
      }
    } catch (_) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => 'unknown',
      );
    }
  }

  Future<void> signUpWithEmail({
    required String displayName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: () => null);
    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(
        displayName: user.displayName,
        email: user.email,
        uid: () => user.uid,
        pendingVerification: true,
        status: AuthStatus.unauthenticated,
        errorMessage: () => null,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => e.code,
      );
    } catch (_) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => 'unknown',
      );
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: () => null);
    try {
      final user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      state = state.copyWith(
        displayName: user.displayName,
        email: user.email,
        photoUrl: () => user.photoUrl,
        uid: () => user.uid,
        pendingVerification: !user.isEmailVerified,
        status: user.isEmailVerified ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        errorMessage: () => null,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => e.code,
      );
    } catch (_) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => 'unknown',
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    state = state.copyWith(errorMessage: () => null);
    try {
      await _authService.sendEmailVerification();
    } on AuthException catch (e) {
      state = state.copyWith(errorMessage: () => e.code);
    } catch (_) {
      state = state.copyWith(errorMessage: () => 'resend_error');
    }
  }

  Future<void> checkEmailVerified() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final verified = await _authService.reloadUser();
      if (verified) {
        state = state.copyWith(
          pendingVerification: false,
          status: AuthStatus.authenticated,
          errorMessage: () => null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: () => 'not_verified',
        );
      }
    } catch (_) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: () => 'verify_error',
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: () => null);
    try {
      await _authService.sendPasswordResetEmail(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => e.code,
      );
    } catch (_) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: () => 'recovery_error',
      );
    }
  }

  Future<void> _syncAfterLogin({String? uid}) async {
    final uidToUse = uid ?? state.uid;
    if (uidToUse == null || _prefs == null) return;
    await _cloudSync.loadAll(uidToUse, _prefs!);
  }

  Future<void> signOut() async {
    try {
      final uid = state.uid;
      if (uid != null && _prefs != null) {
        await _cloudSync.saveAll(uid, _prefs!);
        await _cloudSync.clearLocal(_prefs!);
      }
      _cloudSync.stopListening();
      await _authService.signOut();
    } catch (_) {}
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> deleteAccount() async {
    _cloudSync.stopListening();
    await _authService.deleteAccount();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }
}
