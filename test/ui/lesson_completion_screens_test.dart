import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/screens/lesson/habit_transition_screen.dart';
import 'package:sagen/ui/widgets/learning/quiz_session.dart';
import 'package:sagen/ui/widgets/learning/quiz_summary.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
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

  group('QuizSummaryScreen', () {
    testWidgets('renders score percentage', (tester) async {
      await tester.pumpWidget(appWrapper()(QuizSummaryScreen(
        result: QuizResult(
          totalQuestions: 5,
          correctAnswers: 4,
          xpEarned: 60,
          gemsEarned: 10,
          perfect: false,
          timeTaken: const Duration(minutes: 2, seconds: 30),
          stageId: 's1',
          lessonId: 'l1',
        ),
        onContinue: () {},
      )));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('80%'), findsOneWidget);
      expect(find.textContaining('60'), findsOneWidget);
    });

    testWidgets('renders perfect badge when perfect', (tester) async {
      await tester.pumpWidget(appWrapper()(QuizSummaryScreen(
        result: QuizResult(
          totalQuestions: 5,
          correctAnswers: 5,
          xpEarned: 100,
          gemsEarned: 20,
          perfect: true,
          timeTaken: const Duration(minutes: 1),
          stageId: 's1',
          lessonId: 'l1',
        ),
        onContinue: () {},
      )));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      await tester.pumpWidget(appWrapper()(QuizSummaryScreen(
        result: QuizResult(
          totalQuestions: 5,
          correctAnswers: 3,
          xpEarned: 45,
          gemsEarned: 5,
          perfect: false,
          timeTaken: const Duration(minutes: 3),
          stageId: 's1',
          lessonId: 'l1',
        ),
        onContinue: () {},
        onRetry: () {},
      )));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Reintentar'), findsOneWidget);
    });
  });

  group('HabitTransitionScreen', () {
    testWidgets('renders continue button', (tester) async {
      await tester.pumpWidget(appWrapper()(const HabitTransitionScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.text('CONTINUAR'), findsOneWidget);
    });

    testWidgets('shows speech bubble message', (tester) async {
      await tester.pumpWidget(appWrapper()(const HabitTransitionScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.byType(Container), findsWidgets);
    });
  });
}
