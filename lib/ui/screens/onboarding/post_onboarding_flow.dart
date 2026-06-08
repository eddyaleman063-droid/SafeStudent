import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/auth_models.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import '../../../services/analytics_service.dart';
import '../../../services/firestore_service.dart';
import '../../screens/lesson/first_lesson_screen.dart';
import '../../screens/lesson/lesson_stats_screen.dart';
import '../../screens/streak/streak_intro_screen.dart';
import '../../screens/streak/commitment_selection_screen.dart';
import '../../screens/registration/profile_hook_screen.dart';
import '../../screens/registration/age_input_screen.dart';
import '../../screens/registration/auth_method_screen.dart';
import '../../screens/registration/email_input_screen.dart';
import '../../screens/registration/password_input_screen.dart';
import '../../screens/registration/name_input_screen.dart';
import '../../screens/registration/profile_success_screen.dart';
import 'post_onboarding_welcome_screen.dart';
import 'quiz_intro_screen.dart';
import 'route_selection_screen.dart';
import 'referral_source_screen.dart';
import 'level_assessment_screen.dart';
import 'diagnosis_confirmation_screen.dart';
import 'motivation_screen.dart';
import 'routine_transition_screen.dart';
import 'daily_goal_screen.dart';
import 'projection_screen.dart';
import 'starting_point_screen.dart';

class PostOnboardingFlow extends ConsumerStatefulWidget {
  const PostOnboardingFlow({super.key});

  @override
  ConsumerState<PostOnboardingFlow> createState() => _PostOnboardingFlowState();
}

class _PostOnboardingFlowState extends ConsumerState<PostOnboardingFlow> {
  int _step = 0;

  void _advance() => setState(() => _step++);

  void _goToHome() {
    ref.read(registrationFunnelProvider.notifier).skipToHome();
    context.goNamed('main');
  }

  Future<void> _completeRegistration() async {
    final authNotifier = ref.read(authProvider.notifier);
    final funnel = ref.read(registrationFunnelProvider);
    if (funnel.authMethod == 'google') {
      await authNotifier.signInWithGoogle();
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        _createProfile(auth, funnel);
        AnalyticsService.instance.track(AnalyticEvent.signUp, properties: {
          'method': 'google',
        });
        AnalyticsService.instance.track(AnalyticEvent.tutorialComplete);
        _advance();
      } else if (auth.errorMessage != null) {
        SagenNotification.show(context, message: AuthException(auth.errorMessage!).localizedMessage(AppLocalizations.of(context)!));
      }
    } else if (funnel.authMethod == 'email') {
      await authNotifier.signUpWithEmail(
        displayName: '${funnel.name} ${funnel.surname}'.trim(),
        email: funnel.email,
        password: funnel.password,
      );
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.showVerificationScreen || auth.isAuthenticated) {
        _createProfile(auth, funnel);
        AnalyticsService.instance.track(AnalyticEvent.signUp, properties: {
          'method': 'email',
        });
        AnalyticsService.instance.track(AnalyticEvent.tutorialComplete);
        _advance();
      } else if (auth.errorMessage != null) {
        SagenNotification.show(context, message: AuthException(auth.errorMessage!).localizedMessage(AppLocalizations.of(context)!));
      }
    }
  }

  void _createProfile(AuthState auth, dynamic funnel) {
    try {
      final uid = ref.read(authServiceProvider).currentUser?.uid;
      if (uid == null) return;
      FirestoreService.instance.createUserProfile(
        uid: uid,
        firstName: funnel.name,
        lastName: funnel.surname,
        email: funnel.email.isNotEmpty ? funnel.email : auth.email,
        age: funnel.age,
      );
    } catch (_) {}
  }

  void _onAuthMethodSelected(String method) {
    if (method == 'google') {
      _completeRegistration();
    } else {
      _advance();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (_step) {
      case 0:
        screen = PostOnboardingWelcomeScreen(
          onContinue: _advance,
          onBack: _goToHome,
        );
        break;
      case 1:
        screen = QuizIntroScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 2:
        screen = RouteSelectionScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 3:
        screen = ReferralSourceScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 4:
        screen = LevelAssessmentScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 5:
        screen = DiagnosisConfirmationScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 6:
        screen = MotivationScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 7:
        screen = RoutineTransitionScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 8:
        screen = DailyGoalScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 9:
        screen = ProjectionScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 10:
        screen = StartingPointScreen(
          onContinue: _advance,
          onBack: () => setState(() => _step--),
        );
        break;
      case 11:
        screen = FirstLessonScreen(onComplete: _advance);
        break;
      case 12:
        screen = LessonStatsScreen(onRecibirXp: _advance);
        break;
      case 13:
        screen = StreakIntroScreen(onContinue: _advance);
        break;
      case 14:
        screen = CommitmentSelectionScreen(
          onCommit: () {
            ref.read(registrationFunnelProvider.notifier).nextStep();
            _advance();
          },
        );
        break;
      case 15:
        screen = ProfileHookScreen(
          onCreateProfile: _advance,
          onSkipToHome: _goToHome,
        );
        break;
      case 16:
        screen = AgeInputScreen(onContinue: _advance);
        break;
      case 17:
        screen = AuthMethodScreen(onContinue: () => _onAuthMethodSelected(
          ref.read(registrationFunnelProvider).authMethod,
        ));
        break;
      case 18:
        final state = ref.watch(registrationFunnelProvider);
        screen = state.authMethod == 'email'
            ? EmailInputScreen(onContinue: _advance)
            : const SizedBox.shrink();
        break;
      case 19:
        final state = ref.watch(registrationFunnelProvider);
        screen = state.authMethod == 'email'
            ? PasswordInputScreen(onContinue: _advance)
            : const SizedBox.shrink();
        break;
      case 20:
        screen = NameInputScreen(onContinue: _completeRegistration);
        break;
      case 21:
        screen = const ProfileSuccessScreen();
        break;
      default:
        screen = const SizedBox.shrink();
    }
    return screen;
  }
}
