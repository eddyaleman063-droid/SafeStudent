import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/screens/payment/payment_failed_screen.dart';
import 'package:sagen/ui/screens/payment/payment_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Widget Function(Widget) appWrapper() {
    return (Widget child) => ProviderScope(
          overrides: [
            prefsProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp(
            locale: const Locale('es'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: child,
          ),
        );
  }

  group('PaymentSuccessScreen', () {
    testWidgets('renders gem count text', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentSuccessScreen(gems: 100)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('100'), findsWidgets);
      expect(find.text('Volver a SAGEN'), findsOneWidget);
    });

    testWidgets('renders check icon', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentSuccessScreen(gems: 50)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('volver button has correct text', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentSuccessScreen(gems: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Volver a SAGEN'), findsOneWidget);
    });
  });

  group('PaymentFailedScreen', () {
    testWidgets('renders error title', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentFailedScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Pago no completado'), findsOneWidget);
    });

    testWidgets('renders error message when provided', (tester) async {
      await tester.pumpWidget(appWrapper()(
        const PaymentFailedScreen(error: 'Tarjeta rechazada'),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Tarjeta rechazada'), findsOneWidget);
    });

    testWidgets('does not render error text when null', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentFailedScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Tarjeta rechazada'), findsNothing);
    });

    testWidgets('renders retry and home buttons', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentFailedScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Intentar de nuevo'), findsOneWidget);
      expect(find.text('Ir al inicio'), findsOneWidget);
    });

    testWidgets('renders close icon', (tester) async {
      await tester.pumpWidget(appWrapper()(const PaymentFailedScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });
  });
}
