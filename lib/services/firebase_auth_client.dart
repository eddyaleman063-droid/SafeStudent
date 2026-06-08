import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'app_logger.dart';
import 'auth_models.dart';

class FirebaseAuthClient {
  final AppLogger _logger;
  firebase.FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;

  FirebaseAuthClient({AppLogger? logger}) : _logger = logger ?? AppLogger();

  bool get isAvailable => _auth != null;
  firebase.User? get firebaseUser => _auth?.currentUser;

  Stream<firebase.User?> get authStateChanges =>
      _auth?.authStateChanges() ?? const Stream.empty();

  void init() {
    try {
      _auth = firebase.FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
    } catch (e) {
      _logger.error('FirebaseAuthClient: FirebaseAuth unavailable', e);
    }
  }

  AppUser appUserFromFirebase(firebase.User user) {
    return AppUser(
      uid: user.uid,
      displayName: user.displayName ?? user.email?.split('@').first ?? 'Estudiante',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
    );
  }

  Future<AppUser> signInWithGoogle() async {
    if (!isAvailable) {
      throw const AuthException('firebase_unavailable');
    }
    try {
      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        throw const AuthException('canceled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth!.signInWithCredential(credential);
      final fbUser = result.user;
      if (fbUser == null) {
        throw const AuthException('null_user');
      }
      return appUserFromFirebase(fbUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const AuthException('unknown');
    }
  }

  Future<AppUser> signInWithFacebook() async {
    if (!isAvailable) {
      throw const AuthException('firebase_unavailable');
    }
    try {
      final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
      if (result.status == LoginStatus.cancelled) {
        throw const AuthException('canceled');
      }
      if (result.status != LoginStatus.success) {
        throw const AuthException('unknown');
      }
      final accessToken = result.accessToken;
      if (accessToken == null) {
        throw const AuthException('null_token');
      }
      final credential = firebase.FacebookAuthProvider.credential(accessToken.tokenString);
      final fbResult = await _auth!.signInWithCredential(credential);
      final fbUser = fbResult.user;
      if (fbUser == null) {
        throw const AuthException('null_user');
      }
      return appUserFromFirebase(fbUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const AuthException('unknown');
    }
  }

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!isAvailable) {
      throw const AuthException('firebase_unavailable');
    }
    try {
      final result = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(displayName.trim());
      final fbUser = result.user;
      if (fbUser == null) {
        throw const AuthException('null_user');
      }
      await fbUser.sendEmailVerification();
      return appUserFromFirebase(fbUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw const AuthException('unknown');
    }
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!isAvailable) {
      throw const AuthException('firebase_unavailable');
    }
    try {
      final result = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = result.user;
      if (fbUser == null) {
        throw const AuthException('null_user');
      }
      await fbUser.reload();
      return appUserFromFirebase(fbUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw const AuthException('unknown');
    }
  }

  Future<void> sendEmailVerification() async {
    if (!isAvailable) return;
    final user = _auth!.currentUser;
    if (user == null) {
      throw const AuthException('not_authenticated');
    }
    try {
      await user.sendEmailVerification();
    } on firebase.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  Future<bool> reloadUser() async {
    if (!isAvailable) return false;
    try {
      final user = _auth!.currentUser;
      if (user == null) return false;
      await user.reload();
      final reloaded = _auth!.currentUser;
      if (reloaded != null) {
        return reloaded.emailVerified;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!isAvailable) {
      throw const AuthException('firebase_unavailable');
    }
    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  Future<void> signOutFirebase() async {
    try {
      if (_googleSignIn != null) {
        await _googleSignIn!.signOut();
      }
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    if (_auth != null) {
      await _auth!.signOut();
    }
  }

  Future<void> deleteFirebaseUser() async {
    try {
      if (_auth != null) {
        final user = _auth!.currentUser;
        if (user != null) {
          await user.delete();
        }
      }
    } catch (_) {}
    try {
      if (_googleSignIn != null) {
        await _googleSignIn!.disconnect();
      }
    } catch (_) {}
  }

  AuthException _mapFirebaseException(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException('not_found');
      case 'wrong-password':
        return const AuthException('wrong_password');
      case 'invalid-credential':
        return const AuthException('invalid_credential');
      case 'email-already-in-use':
        return const AuthException('email_in_use');
      case 'weak-password':
        return const AuthException('weak_password');
      case 'invalid-email':
        return const AuthException('invalid_email');
      case 'too-many-requests':
        return const AuthException('too_many_requests');
      case 'network-request-failed':
        return const AuthException('network_error');
      default:
        return AuthException(e.code);
    }
  }
}
