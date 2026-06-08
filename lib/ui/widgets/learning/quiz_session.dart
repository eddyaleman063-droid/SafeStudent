import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/models/learning/challenge.dart';
import 'package:sagen/models/learning/lesson_type.dart';

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int xpEarned;
  final int gemsEarned;
  final bool perfect;
  final Duration timeTaken;
  final String stageId;
  final String lessonId;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.xpEarned,
    required this.gemsEarned,
    required this.perfect,
    required this.timeTaken,
    required this.stageId,
    required this.lessonId,
  });

  double get score => totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
}

class QuizSession extends ConsumerStatefulWidget {
  final List<Challenge> challenges;
  final String stageId;
  final String lessonId;
  final String lessonTitle;
  final ValueChanged<QuizResult> onComplete;

  const QuizSession({
    super.key,
    required this.challenges,
    required this.stageId,
    required this.lessonId,
    required this.lessonTitle,
    required this.onComplete,
  });

  @override
  ConsumerState<QuizSession> createState() => _QuizSessionState();
}

class _QuizSessionState extends ConsumerState<QuizSession>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _correctCount = 0;
  int? _selectedIndex;
  bool _answered = false;
  final DateTime _startTime = DateTime.now();
  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackAnim;

  Challenge get _current => widget.challenges[_currentIndex];
  bool get _isLast => _currentIndex >= widget.challenges.length - 1;

  @override
  void initState() {
    super.initState();
    _feedbackCtrl = AnimationController(
      vsync: this,
      duration: AppMotion.fast,
    );
    _feedbackAnim = CurvedAnimation(
      parent: _feedbackCtrl,
      curve: AppEasing.entrance,
    );
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    final correct = index == _current.correctIndex;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (correct) _correctCount++;
    });
    _feedbackCtrl.forward();
    if (!correct) {
      try {
        final learning = ref.read(learningProvider);
        final stage = learning.stages.firstWhere((s) => s.id == widget.stageId);
        ref.read(reviewProvider.notifier).recordMistake(_current.id, stage.title);
      } catch (_) {}
    }
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _answered = false;
    });
    _feedbackCtrl.reverse();
  }

  void _finish() {
    final timeTaken = DateTime.now().difference(_startTime);
    final total = widget.challenges.length;
    final correct = _correctCount;
    final perfect = correct == total;
    const xpPerQuestion = 15;
    const gemPerQuestion = 3;
    final bonusMultiplier = perfect ? 1.5 : 1.0;

    widget.onComplete(QuizResult(
      totalQuestions: total,
      correctAnswers: correct,
      xpEarned: ((total * xpPerQuestion) * bonusMultiplier).round(),
      gemsEarned: ((correct * gemPerQuestion) * bonusMultiplier).round(),
      perfect: perfect,
      timeTaken: timeTaken,
      stageId: widget.stageId,
      lessonId: widget.lessonId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final progress = widget.challenges.isEmpty
        ? 1.0
        : (_currentIndex / widget.challenges.length).clamp(0.0, 1.0);

    return Column(
      children: [
        _ProgressHeader(
          current: _currentIndex + 1,
          total: widget.challenges.length,
          progress: progress,
          title: widget.lessonTitle,
          dark: dark,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionCard(
                  challenge: _current,
                  dark: dark,
                  index: _currentIndex,
                ),
                const SizedBox(height: 16),
                ...List.generate(_current.options.length, (i) {
                  return _OptionButton(
                    index: i,
                    text: _current.options[i],
                    selected: _selectedIndex == i,
                    correct: _current.correctIndex == i,
                    revealed: _answered,
                    dark: dark,
                    onTap: () => _selectAnswer(i),
                  );
                }),
                if (_answered) ...[
                  FadeTransition(
                    opacity: _feedbackAnim,
                    child: _FeedbackCard(
                      correct: _selectedIndex == _current.correctIndex,
                      explanation: _current.explanation,
                      dark: dark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _next,
                      icon: Icon(
                        _isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _isLast ? AppLocalizations.of(context)!.firstLessonSeeResults : AppLocalizations.of(context)!.nextText,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PremiumColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int current;
  final int total;
  final double progress;
  final String title;
  final bool dark;

  const _ProgressHeader({
    required this.current,
    required this.total,
    required this.progress,
    required this.title,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1A2035) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: dark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.close_rounded, size: 18, color: dark ? Colors.white70 : Colors.black54),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: dark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$current / $total',
                style: TextStyle(
                  fontSize: 13,
                  color: dark ? Colors.white54 : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: dark ? Colors.white10 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                PremiumColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Challenge challenge;
  final bool dark;
  final int index;

  const _QuestionCard({
    required this.challenge,
    required this.dark,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = _typeLabel(challenge.type, context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            challenge.color.withValues(alpha: 0.08),
            challenge.color.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: challenge.color.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: challenge.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  typeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: challenge.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            challenge.question,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white : const Color(0xFF1A1A2E),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(LessonType type, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (type) {
      case LessonType.trueFalse: return l.challengeTrueFalse;
      case LessonType.multipleChoice: return l.challengeMultiple;
      case LessonType.completePhrase: return l.challengeComplete;
      case LessonType.detectRisk: return l.challengeDetectRisk;
      case LessonType.createPassword: return l.challengeCreatePassword;
      case LessonType.whatWouldYouDo: return l.challengeWhatWouldYouDo;
      case LessonType.miniCase: return l.challengeMiniCase;
    }
  }
}

class _OptionButton extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final bool correct;
  final bool revealed;
  final bool dark;
  final VoidCallback onTap;

  const _OptionButton({
    required this.index,
    required this.text,
    required this.selected,
    required this.correct,
    required this.revealed,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color? borderColor;
    Color? textColor;
    String? prefix;

    if (revealed) {
      if (correct) {
        bgColor = PremiumColors.success.withValues(alpha: 0.1);
        borderColor = PremiumColors.success;
        textColor = PremiumColors.success;
        prefix = '✓';
      } else if (selected && !correct) {
        bgColor = PremiumColors.error.withValues(alpha: 0.1);
        borderColor = PremiumColors.error;
        textColor = PremiumColors.error;
        prefix = '✗';
      } else {
        bgColor = dark ? const Color(0xFF1A2035) : Colors.white;
        borderColor = dark ? Colors.white12 : Colors.grey.shade200;
        textColor = dark ? Colors.white54 : Colors.grey;
      }
    } else {
      bgColor = dark ? const Color(0xFF1A2035) : Colors.white;
      borderColor = dark ? Colors.white12 : Colors.grey.shade200;
      textColor = dark ? Colors.white : Colors.black87;
    }

    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: revealed ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: revealed && (correct || (selected && !correct)) ? 1.5 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected && revealed && correct
                        ? PremiumColors.success
                        : selected && revealed && !correct
                            ? PremiumColors.error
                            : dark
                                ? Colors.white10
                                : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      prefix ?? letters[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selected && revealed
                            ? Colors.white
                            : textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final bool correct;
  final String explanation;
  final bool dark;

  const _FeedbackCard({
    required this.correct,
    required this.explanation,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xxs),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: correct
            ? PremiumColors.success.withValues(alpha: 0.06)
            : PremiumColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: correct
              ? PremiumColors.success.withValues(alpha: 0.2)
              : PremiumColors.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: correct
                  ? PremiumColors.success.withValues(alpha: 0.1)
                  : PremiumColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(
              correct ? Icons.check_rounded : Icons.info_rounded,
              size: 16,
              color: correct ? PremiumColors.success : PremiumColors.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correct ? AppLocalizations.of(context)!.sessionCorrect : AppLocalizations.of(context)!.sessionIncorrect,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: correct ? PremiumColors.success : PremiumColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 12,
                    color: dark ? Colors.white54 : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
