import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/models/learning/lesson.dart';
import 'package:sagen/models/learning/stage.dart';
import 'package:sagen/providers/dashboard_provider.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/screens/dashboard/dashboard_home_screen.dart';
import 'package:sagen/ui/widgets/shimmer_loading.dart';

class _TestState {
  static DashboardState dashState = const DashboardState();
  static LearningState learnState = const LearningState();
}

class _TestDashboardNotifier extends DashboardNotifier {
  @override
  DashboardState build() => _TestState.dashState;
}

class _TestLearningNotifier extends LearningNotifier {
  @override
  LearningState build() => _TestState.learnState;
}

Widget createTestApp({
  DashboardState? dashState,
  LearningState? learnState,
}) {
  _TestState.dashState = dashState ?? const DashboardState();
  _TestState.learnState = learnState ?? const LearningState(isLoading: false);
  return ProviderScope(
    overrides: [
      dashboardProvider.overrideWith(() => _TestDashboardNotifier()),
      learningProvider.overrideWith(() => _TestLearningNotifier()),
    ],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DashboardHomeScreen(),
    ),
  );
}

void main() {
  group('DashboardHomeScreen', () {
    testWidgets('shows shimmer when loading', (tester) async {
      await tester.pumpWidget(createTestApp(
        dashState: const DashboardState(isLoading: true),
        learnState: const LearningState(isLoading: true),
      ));
      await tester.pump();
      expect(find.byType(ShimmerLoading), findsWidgets);
    });

    testWidgets('shows header with display name', (tester) async {
      await tester.pumpWidget(createTestApp(
        dashState: const DashboardState(displayName: 'Ariana', isLoading: false),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Ariana'), findsOneWidget);
    });

    testWidgets('shows hero mission card when next lesson exists', (tester) async {
      final lesson = Lesson(
        id: 'l1',
        title: 'Phishing 101',
        subtitle: 'Aprende a identificar',
        challenges: [],
      );
      final stage = Stage(
        id: 's1',
        title: 'Fundamentos',
        subtitle: 'Base',
        accent: Colors.blue,
        icon: Icons.shield_rounded,
        lessons: [lesson],
        unlocked: true,
      );
      await tester.pumpWidget(createTestApp(
        dashState: DashboardState(
          displayName: 'Test', isLoading: false,
          nextLesson: lesson, nextLessonStageTitle: 'Fundamentos',
        ),
        learnState: LearningState(stages: [stage], isLoading: false),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Phishing 101'), findsOneWidget);
      expect(find.textContaining('Fundamentos'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows learning path stages', (tester) async {
      final stage = Stage(
        id: 's1',
        title: 'Ciberseguridad 1',
        subtitle: 'Introducción',
        accent: Colors.teal,
        icon: Icons.shield_rounded,
        lessons: [],
        unlocked: true,
      );
      await tester.pumpWidget(createTestApp(
        dashState: const DashboardState(displayName: 'Test', isLoading: false),
        learnState: LearningState(stages: [stage], isLoading: false),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Ciberseguridad 1'), findsOneWidget);
    });

    testWidgets('shows all complete message when no next lesson', (tester) async {
      await tester.pumpWidget(createTestApp(
        dashState: const DashboardState(
          displayName: 'Test', isLoading: false,
          nextLesson: null, nextLessonStageTitle: null,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('¡Todo completo!'), findsOneWidget);
    });
  });
}
