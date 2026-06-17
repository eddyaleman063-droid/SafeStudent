import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthState', () {
    test('initial state is uninitialized', () {
      const state = AuthState();
      expect(state.status, AuthStatus.uninitialized);
      expect(state.isAuthenticated, false);
      expect(state.displayName, '');
      expect(state.email, '');
      expect(state.uid, isNull);
      expect(state.pendingVerification, false);
    });

    test('copyWith updates only specified fields', () {
      const state = AuthState();
      final updated = state.copyWith(
        status: AuthStatus.authenticated,
        uid: () => 'test-uid',
        displayName: 'Test User',
      );
      expect(updated.status, AuthStatus.authenticated);
      expect(updated.uid, 'test-uid');
      expect(updated.displayName, 'Test User');
      expect(updated.email, '');
      expect(updated.pendingVerification, false);
    });

    test('isAuthenticated is true only for authenticated status', () {
      const unauthenticated = AuthState(status: AuthStatus.unauthenticated);
      const authenticated = AuthState(status: AuthStatus.authenticated);
      const loading = AuthState(status: AuthStatus.loading);
      const error = AuthState(status: AuthStatus.error);
      expect(unauthenticated.isAuthenticated, false);
      expect(authenticated.isAuthenticated, true);
      expect(loading.isAuthenticated, false);
      expect(error.isAuthenticated, false);
    });

    test('showVerificationScreen is true when pendingVerification', () {
      const pending = AuthState(pendingVerification: true);
      const notPending = AuthState();
      expect(pending.showVerificationScreen, true);
      expect(notPending.showVerificationScreen, false);
    });
  });

  group('AuthNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final mockAuth = MockAuthService();
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.authStateChanges).thenAnswer((_) => const Stream.empty());
      container = ProviderContainer(overrides: [
        authServiceProvider.overrideWith((ref) => mockAuth),
        prefsProvider.overrideWithValue(prefs),
      ]);
    });

    tearDown(() => container.dispose());

    test('initial auth state has correct defaults', () {
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.isAuthenticated, false);
    });
  });
}
