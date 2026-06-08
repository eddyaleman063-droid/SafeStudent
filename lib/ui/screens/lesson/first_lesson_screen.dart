import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../models/learning/challenge.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/widgets/shimmer_loading.dart';

class FirstLessonScreen extends ConsumerWidget {
  final VoidCallback onComplete;

  const FirstLessonScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final lesson = ref.watch(firstLessonProvider);
    final notifier = ref.read(firstLessonProvider.notifier);

    if (lesson.questions.isEmpty) {
      notifier.startLesson();
      return Scaffold(
        backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
        body: const _FirstLessonShimmer(),
      );
    }

    if (lesson.isComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onComplete());
      return Scaffold(
        backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final q = lesson.currentChallenge;
    if (q == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.school_rounded, color: PremiumColors.splashBlue, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l.firstLessonProgress(lesson.currentIndex + 1, lesson.totalQuestions),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${((lesson.currentIndex / lesson.totalQuestions) * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: PremiumColors.splashBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: lesson.currentIndex / lesson.totalQuestions,
                  backgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                  valueColor: const AlwaysStoppedAnimation(PremiumColors.splashBlue),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _QuestionBody(
                    key: ValueKey(lesson.currentIndex),
                    question: q,
                    showFeedback: lesson.showFeedback,
                    selectedAnswer: lesson.selectedAnswer,
                    answeredCorrectly: lesson.answeredCorrectly,
                    isLastQuestion: lesson.currentIndex + 1 >= lesson.totalQuestions,
                    dark: dark,
                    onSelect: (index) => notifier.submitAnswer(index),
                    onNext: () => notifier.nextQuestion(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FirstLessonShimmer extends StatelessWidget {
  const _FirstLessonShimmer();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerLoading(width: 280, height: 20),
          SizedBox(height: AppSpacing.xxl),
          ShimmerLoading(width: double.infinity, height: 56, borderRadius: AppRadius.lg),
          SizedBox(height: AppSpacing.md),
          ShimmerLoading(width: double.infinity, height: 56, borderRadius: AppRadius.lg),
          SizedBox(height: AppSpacing.md),
          ShimmerLoading(width: double.infinity, height: 56, borderRadius: AppRadius.lg),
        ],
      ),
    );
  }
}

class _QuestionBody extends StatelessWidget {
  final Challenge question;
  final bool showFeedback;
  final int? selectedAnswer;
  final bool answeredCorrectly;
  final bool isLastQuestion;
  final bool dark;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  const _QuestionBody({
    super.key,
    required this.question,
    required this.showFeedback,
    required this.selectedAnswer,
    required this.answeredCorrectly,
    required this.isLastQuestion,
    required this.dark,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ...List.generate(question.options.length, (i) {
          final opt = question.options[i];
          final isSelected = selectedAnswer == i;
          final isCorrect = i == question.correctIndex;

          Color? tileColor;
          Color? borderColor;
          if (showFeedback) {
            if (isCorrect) {
              tileColor = PremiumColors.success.withValues(alpha: 0.12);
              borderColor = PremiumColors.success;
            } else if (isSelected && !isCorrect) {
              tileColor = PremiumColors.error.withValues(alpha: 0.12);
              borderColor = PremiumColors.error;
            } else {
              tileColor = dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03);
              borderColor = dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06);
            }
          } else {
            tileColor = dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03);
            borderColor = dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: GestureDetector(
              onTap: showFeedback ? null : () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: tileColor,
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      showFeedback && isCorrect
                          ? Icons.check_circle_rounded
                          : showFeedback && isSelected && !isCorrect
                              ? Icons.cancel_rounded
                              : Icons.radio_button_unchecked_rounded,
                      size: 20,
                      color: showFeedback && isCorrect
                          ? PremiumColors.success
                          : showFeedback && isSelected && !isCorrect
                              ? PremiumColors.error
                              : dark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 15,
                          color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (showFeedback) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: answeredCorrectly
                  ? PremiumColors.success.withValues(alpha: 0.08)
                  : PremiumColors.error.withValues(alpha: 0.08),
              border: Border.all(
                color: answeredCorrectly
                    ? PremiumColors.success.withValues(alpha: 0.2)
                    : PremiumColors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  answeredCorrectly ? Icons.check_circle_rounded : Icons.info_rounded,
                  size: 18,
                  color: answeredCorrectly ? PremiumColors.success : PremiumColors.error,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    question.explanation,
                    style: TextStyle(
                      fontSize: 13,
                      color: answeredCorrectly
                          ? (dark ? Colors.white.withValues(alpha: 0.7) : Colors.black87)
                          : (dark ? Colors.white.withValues(alpha: 0.7) : Colors.black87),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: PremiumColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              ),
              child: Text(
                isLastQuestion ? l.firstLessonSeeResults : l.nextText.toUpperCase(),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        ],
      );
    }
  }
