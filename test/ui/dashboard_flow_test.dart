// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/dashboard_provider.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/screens/main_layout.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Future<void> flushTimers(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
  }

  Widget createTestApp({DashboardNotifier? notifier}) {
    final testNotifier = notifier ?? DashboardNotifier();
    return ProviderScope(
      overrides: [
        dashboardProvider.overrideWith(() => testNotifier),
        prefsProvider.overrideWithValue(prefs),
        leaderboardProvider.overrideWith((ref) => Stream.value(const <LeaderboardEntry>[
          LeaderboardEntry(uid: '1', displayName: 'Ariana Reyes', totalXp: 3200),
          LeaderboardEntry(uid: '2', displayName: 'Carlos Mtz', totalXp: 2850),
          LeaderboardEntry(uid: '3', displayName: 'Luisa Fernanda', totalXp: 2410),
          LeaderboardEntry(uid: '4', displayName: 'Pedro Ramirez', totalXp: 2100),
          LeaderboardEntry(uid: '5', displayName: 'Sofia Torres', totalXp: 1890),
        ])),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MainLayout(),
      ),
    );
  }

  group('MainLayout & PremiumNavBar', () {
    testWidgets('renders all 5 nav tabs with correct labels', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await flushTimers(tester);

      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Cofre'), findsOneWidget);
      expect(find.text('Sage'), findsOneWidget);
      expect(find.text('Clasificación'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('tapping a tab calls setActiveTab and changes provider state',
        (tester) async {
      final notifier = DashboardNotifier();
      await tester.pumpWidget(createTestApp(notifier: notifier));
      await tester.pump();
      await flushTimers(tester);

      expect(notifier.activeTab, 0);

      await tester.tap(find.text('Cofre'));
      await tester.pump();
      await flushTimers(tester);

      expect(notifier.activeTab, 1);
    });

    testWidgets('tapping same tab does not change state', (tester) async {
      final notifier = DashboardNotifier();
      await tester.pumpWidget(createTestApp(notifier: notifier));
      await tester.pump();
      await flushTimers(tester);

      expect(notifier.activeTab, 0);

      await tester.tap(find.text('Inicio'));
      await tester.pump();
      await flushTimers(tester);

      expect(notifier.activeTab, 0);
    });

    testWidgets('animating flag prevents rapid duplicate tab switches',
        (tester) async {
      final notifier = DashboardNotifier();
      await tester.pumpWidget(createTestApp(notifier: notifier));
      await tester.pump();
      await flushTimers(tester);

      expect(notifier.activeTab, 0);

      await tester.tap(find.text('Cofre'));
      await tester.pump();

      await tester.tap(find.text('Sage'));
      await tester.pump();

      expect(notifier.activeTab, 1);
      await flushTimers(tester);
    });

    testWidgets('initial tab is 0 by default', (tester) async {
      final notifier = DashboardNotifier();
      await tester.pumpWidget(createTestApp(notifier: notifier));
      await tester.pump();
      await flushTimers(tester);

      expect(notifier.activeTab, 0);
    });
  });
}
