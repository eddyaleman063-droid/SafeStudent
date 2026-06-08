import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/welcome_screen.dart';
import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/forgot_password_screen.dart';
import '../ui/screens/onboarding/onboarding_wizard_screen.dart';
import '../ui/screens/onboarding/post_onboarding_flow.dart';
import '../ui/screens/main_layout.dart';
import '../ui/screens/dashboard/lessons_screen.dart';
import '../ui/screens/dashboard/user_profile_screen.dart';
import '../ui/screens/lesson/lesson_session_screen.dart';
import '../ui/screens/lesson/lesson_results_screen.dart';
import '../ui/screens/lesson/learning_session_screen.dart';
import '../models/learning/quiz_score.dart';
import '../ui/screens/lesson/session_summary_screen.dart';
import '../ui/screens/lesson/habit_transition_screen.dart';
import '../ui/screens/streak/daily_streak_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final location = state.matchedLocation;

      if (auth.isUninitialized || auth.isLoading) {
        if (location != '/') return '/';
        return null;
      }

      if (!auth.isAuthenticated) {
        final publicRoutes = <String>{
          '/', '/welcome', '/login', '/forgot-password',
          '/onboarding', '/onboarding/flow',
        };
        if (!publicRoutes.contains(location)) return '/welcome';
        return null;
      }

      if (auth.isAuthenticated) {
        final authRoutes = <String>{
          '/', '/welcome', '/login', '/forgot-password',
          '/onboarding', '/onboarding/flow',
        };
        if (authRoutes.contains(location)) return '/main';
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(autoNavigate: false),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final isOnboarding = state.uri.queryParameters['onboarding'] == 'true';
          return LoginScreen(isOnboarding: isOnboarding);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingWizardScreen(),
      ),
      GoRoute(
        path: '/onboarding/flow',
        name: 'onboarding-flow',
        builder: (context, state) => const PostOnboardingFlow(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: '/lessons',
        name: 'lessons',
        builder: (context, state) => const LessonsScreen(),
      ),
      GoRoute(
        path: '/lesson/:stageId/:lessonId',
        name: 'lesson-session',
        builder: (context, state) => LessonSessionScreen(
          stageId: state.pathParameters['stageId']!,
          lessonId: state.pathParameters['lessonId']!,
          lessonTitle: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: '/lesson/:stageId/:lessonId/results',
        name: 'lesson-results',
        builder: (context, state) => LessonResultsScreen(
          stageId: state.pathParameters['stageId']!,
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
      GoRoute(
        path: '/learning/:stageId/:lessonId',
        name: 'learning-session',
        builder: (context, state) => LearningSessionScreen(
          stageId: state.pathParameters['stageId']!,
          lessonId: state.pathParameters['lessonId']!,
          lessonTitle: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: '/quiz-summary',
        name: 'quiz-summary',
        builder: (context, state) => SessionSummaryScreen(
          score: state.extra as QuizScoreCalculator,
        ),
      ),
      GoRoute(
        path: '/habit-transition',
        name: 'habit-transition',
        builder: (context, state) => const HabitTransitionScreen(),
      ),
      GoRoute(
        path: '/streak',
        name: 'streak',
        builder: (context, state) => const DailyStreakScreen(),
      ),
      GoRoute(
        path: '/profile/:uid',
        name: 'profile',
        builder: (context, state) => UserProfileScreen(
          uid: state.pathParameters['uid']!,
        ),
      ),
    ],
  );

  ref.listen(authProvider, (_, _) => router.refresh());
  ref.onDispose(() => router.dispose());

  return router;
});
