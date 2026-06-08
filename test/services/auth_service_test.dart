import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/services/auth_service.dart';

class AuthException {
  final String message;
  final String code;
  const AuthException(this.message, this.code);
  @override
  String toString() => message;
}

void main() {
  group('AuthService', () {
    test('AppUser stores user data', () {
      const user = AppUser(
        uid: '123',
        displayName: 'Test',
        email: 'test@example.com',
        photoUrl: 'url',
      );
      expect(user.uid, '123');
      expect(user.displayName, 'Test');
      expect(user.email, 'test@example.com');
      expect(user.photoUrl, 'url');
    });
    test('AppUser defaults to Estudiante', () {
      const user = AppUser();
      expect(user.displayName, 'Estudiante');
      expect(user.email, '');
      expect(user.photoUrl, isNull);
    });
    test('AuthException stores message and code', () {
      const e = AuthException('test error', 'TEST_CODE');
      expect(e.message, 'test error');
      expect(e.code, 'TEST_CODE');
      expect(e.toString(), 'test error');
    });
    test('AuthService creates instance', () {
      final service = AuthService();
      expect(service, isNot(null));
    });
    test('initial state is not logged in', () {
      final service = AuthService();
      expect(service.isLoggedIn, false);
      expect(service.displayName, 'Estudiante');
      expect(service.email, '');
      expect(service.currentUser, isNull);
    });
  });
}
