import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen golden test', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WelcomeScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await expectLater(
      find.byType(WelcomeScreen),
      matchesGoldenFile('goldens/welcome_screen.png'),
    );
  });
}
