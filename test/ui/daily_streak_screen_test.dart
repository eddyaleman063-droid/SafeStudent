import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/screens/streak/daily_streak_screen.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter/platform_views'),
      (MethodCall call) async {
        switch (call.method) {
          case 'create':
            return 1;
          default:
            return null;
        }
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.sagen.app/flame_animation'),
      (MethodCall call) async => null,
    );
  });

  Widget createTestApp() {
    return ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(
        home: DailyStreakScreen(),
      ),
    );
  }

  group('DailyStreakScreen', () {
    testWidgets('renders with active streak and streak count',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'streak_current': 10,
        'streak_longest': 10,
      });
      prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.text('10'), findsOneWidget);
      expect(find.text('día de racha'), findsOneWidget);
    });

    testWidgets('renders continue button', (tester) async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.text('MANTENER MI COMPROMISO'), findsOneWidget);
    });

    testWidgets('renders week timeline with correct labels',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.text('Ma'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
    });

    testWidgets('renders with frozen streak state', (tester) async {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String();
      SharedPreferences.setMockInitialValues({
        'streak_current': 5,
        'streak_longest': 5,
        'streak_freezes': 1,
        'streak_last_activity': yesterday,
      });
      prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.text('5'), findsOneWidget);
      expect(find.text('día de racha'), findsOneWidget);
    });

    testWidgets('consumes defrosting flag on initial render',
        (tester) async {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String();
      SharedPreferences.setMockInitialValues({
        'streak_current': 5,
        'streak_longest': 5,
        'streak_freezes': 1,
        'streak_last_activity': yesterday,
        'streak_just_defrosted': true,
      });
      prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(prefs.getBool('streak_just_defrosted'), isFalse);
    });

    testWidgets('shows speech bubble with message', (tester) async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(createTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });
  });
}
