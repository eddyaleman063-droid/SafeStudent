// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/screens/auth/login_screen.dart';
import 'package:sagen/ui/widgets/onboarding/legal_text_block.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Widget createTestApp() {
    return ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders title, email field, password field and login button',
        (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text('Ingresa tus datos'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('INGRESAR'), findsOneWidget);
    });

    testWidgets('renders social auth buttons for Google and Facebook',
        (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text('GOOGLE'), findsOneWidget);
      expect(find.text('FACEBOOK'), findsOneWidget);
    });

    testWidgets('renders reset password link', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text('RESTABLECER CONTRASEÑA'), findsOneWidget);
    });

    testWidgets('renders legal text block', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byType(LegalTextBlock), findsOneWidget);
    });
  });
}
