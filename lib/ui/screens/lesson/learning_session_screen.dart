import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_transitions.dart';
import 'package:sagen/providers/providers.dart';
import '../../../models/learning/challenge.dart';
import '../../../services/question_bank.dart';
import '../../../ui/widgets/common/ambient_background.dart';
import '../../../ui/widgets/common/premium_loader.dart';
import '../../../ui/widgets/learning/quiz_session.dart';
import '../../../ui/widgets/learning/quiz_summary.dart';
import 'package:sagen/l10n/app_localizations.dart';

class LearningSessionScreen extends ConsumerStatefulWidget {
  final String stageId;
  final String lessonId;
  final String lessonTitle;
  final int questionCount;

  const LearningSessionScreen({
    super.key,
    required this.stageId,
    required this.lessonId,
    required this.lessonTitle,
    this.questionCount = 5,
  });

  @override
  ConsumerState<LearningSessionScreen> createState() => _LearningSessionScreenState();
}

class _LearningSessionScreenState extends ConsumerState<LearningSessionScreen> {
  bool _loading = true;
  List<Challenge>? _challenges;

  @override
  void initState() {
    super.initState();
    ref.read(loggerProvider).info('LearningSessionScreen: loading questions for ${widget.lessonId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions();
    });
  }

  void _loadQuestions() {
    final questions = QuestionBank.instance.getQuestionsForLesson(
      widget.stageId,
      widget.lessonId,
      count: widget.questionCount,
    );
    ref.read(loggerProvider).info('LearningSessionScreen: loaded ${questions.length} questions');
    if (!mounted) return;
    setState(() {
      _challenges = questions;
      _loading = false;
    });
  }

  void _onComplete(QuizResult result) {
    ref.read(learningProvider.notifier).completeLesson(widget.stageId, widget.lessonId, perfectLesson: result.perfect);
    ref.read(streakProvider.notifier).checkIn();
    ref.read(energyProvider.notifier).consumeForLesson();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      AppTransitions.fade(_SummaryWrapper(result: result, stageId: widget.stageId, lessonId: widget.lessonId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    return AmbientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PremiumLoader(
          loading: _loading,
          message: l.lessonPreparing,
          child: _challenges != null && _challenges!.isNotEmpty
              ? QuizSession(
                  challenges: _challenges!,
                  stageId: widget.stageId,
                  lessonId: widget.lessonId,
                  lessonTitle: widget.lessonTitle,
                  onComplete: _onComplete,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxxl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.quiz_outlined, size: 48, color: dark ? Colors.white24 : Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          l.lessonNoQuestions,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: dark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l.back),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _SummaryWrapper extends StatelessWidget {
  final QuizResult result;
  final String stageId;
  final String lessonId;

  const _SummaryWrapper({
    required this.result,
    required this.stageId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    return AmbientBackground(
      child: QuizSummaryScreen(
        result: result,
        onContinue: () {
          context.goNamed('main');
        },
        onRetry: () {
          context.goNamed(
            'learning-session',
            pathParameters: {
              'stageId': stageId,
              'lessonId': lessonId,
            },
            extra: '',
          );
        },
      ),
    );
  }
}
