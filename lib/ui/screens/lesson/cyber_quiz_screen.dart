import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../models/learning/challenge.dart';
import '../../../models/learning/quiz_score.dart';

enum _AnswerState { idle, correct, incorrect }

class CyberQuizScreen extends StatefulWidget {
  final List<Challenge> questions;
  final String lessonTitle;
  final int timeBudgetSeconds;

  const CyberQuizScreen({
    super.key,
    required this.questions,
    this.lessonTitle = 'Cuestionario',
    this.timeBudgetSeconds = 300,
  });

  @override
  State<CyberQuizScreen> createState() => _CyberQuizScreenState();
}

class _CyberQuizScreenState extends State<CyberQuizScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _selectedAnswer = -1;
  _AnswerState _answerState = _AnswerState.idle;
  int _correctCount = 0;
  DateTime? _sessionStart;

  late AnimationController _shakeCtrl;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _sessionStart = DateTime.now();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Challenge get _question => widget.questions[_currentIndex];
  bool get _isLast => _currentIndex >= widget.questions.length - 1;
  bool get _canCheck => _selectedAnswer >= 0 && _answerState == _AnswerState.idle;
  bool get _isCorrect => _answerState == _AnswerState.correct;

  void _onSelect(int index) {
    if (_answerState != _AnswerState.idle) return;
    setState(() => _selectedAnswer = index);
    HapticFeedback.lightImpact();
  }

  void _onCheck() {
    if (!_canCheck) return;
    final correct = _selectedAnswer == _question.correctIndex;
    setState(() {
      _answerState = correct ? _AnswerState.correct : _AnswerState.incorrect;
      if (correct) _correctCount++;
    });
    if (correct) {
      HapticFeedback.mediumImpact();
      _pulseCtrl.forward(from: 0);
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward(from: 0);
    }
  }

  void _onContinue() {
    if (_answerState == _AnswerState.idle) return;
    if (_isLast) {
      _finishQuiz();
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = -1;
        _answerState = _AnswerState.idle;
      });
    }
  }

  void _finishQuiz() {
    final spent = DateTime.now().difference(_sessionStart!).inSeconds;
    final score = QuizScoreCalculator(
      correctCount: _correctCount,
      totalQuestions: widget.questions.length,
      timeSpentSeconds: spent,
      timeBudgetSeconds: widget.timeBudgetSeconds,
    );
    context.goNamed('quiz-summary', extra: score);
  }

  Future<bool> _onWillPop() async {
    if (_answerState != _AnswerState.idle || _currentIndex > 0 || _selectedAnswer >= 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          final dialogDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
          backgroundColor: dialogDark ? PremiumColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          title: Text('¿Abandonar?', style: TextStyle(color: dialogDark ? Colors.white : Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
          content: Text('Perderás tu progreso actual.', style: TextStyle(color: dialogDark ? Colors.white60 : Colors.black54, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('SEGUIR', style: TextStyle(color: PremiumColors.primaryAccent, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('SALIR', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
        },
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
        body: SafeArea(
          child: Column(
            children: [
              _HudBar(
                currentIndex: _currentIndex,
                total: widget.questions.length,
                title: widget.lessonTitle,
                dark: dark,
                onClose: () async {
                  final shouldPop = await _onWillPop();
                  if (shouldPop && context.mounted) Navigator.pop(context);
                },
                isShaking: _shakeCtrl.isAnimating,
                shakeValue: _shakeCtrl,
              ),
              Expanded(
                child: _buildBody(dark),
              ),
              _buildFooter(dark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(bool dark) {
    final shakeX = sin(_shakeCtrl.value * 6 * pi) * 8 * (1 - _shakeCtrl.value);

    return Transform.translate(
      offset: Offset(shakeX, 0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              _question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            ...List.generate(_question.options.length, (i) {
              final opt = _question.options[i];
              final isSelected = _selectedAnswer == i;
              final isCorrectAnswer = i == _question.correctIndex;
              Color bgColor;
              Color borderColor;
              Color textColor;
              IconData? icon;

              if (_answerState == _AnswerState.idle) {
                bgColor = isSelected
                    ? PremiumColors.primaryAccent.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.04);
                borderColor = isSelected
                    ? PremiumColors.primaryAccent.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.06);
                textColor = isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7);
                icon = isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded;
              } else {
                if (isCorrectAnswer) {
                  bgColor = PremiumColors.success.withValues(alpha: 0.15);
                  borderColor = PremiumColors.success;
                  textColor = Colors.white;
                  icon = Icons.check_circle_rounded;
                } else if (isSelected && !isCorrectAnswer) {
                  bgColor = PremiumColors.error.withValues(alpha: 0.15);
                  borderColor = PremiumColors.error;
                  textColor = Colors.white;
                  icon = Icons.cancel_rounded;
                } else {
                  bgColor = Colors.white.withValues(alpha: 0.03);
                  borderColor = Colors.white.withValues(alpha: 0.04);
                  textColor = Colors.white.withValues(alpha: 0.3);
                  icon = Icons.radio_button_unchecked_rounded;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: GestureDetector(
                  onTap: _answerState == _AnswerState.idle ? () => _onSelect(i) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md + 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      color: bgColor,
                      border: Border.all(color: borderColor, width: _answerState != _AnswerState.idle && (isCorrectAnswer || (isSelected && !isCorrectAnswer)) ? 2.5 : 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 22, color: textColor),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            opt,
                            style: TextStyle(fontSize: 15, color: textColor, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(bool dark) {
    String label;
    Color bgColor;

    if (_answerState == _AnswerState.idle) {
      label = 'COMPROBAR';
      bgColor = PremiumColors.primaryAccent;
    } else if (_isCorrect) {
      label = 'CONTINUAR';
      bgColor = PremiumColors.success;
    } else {
      label = 'CONTINUAR';
      bgColor = PremiumColors.error;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, AppSpacing.xxl),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _answerState == _AnswerState.idle ? _onCheck : _onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.06),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.25),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}

class _HudBar extends StatelessWidget {
  final int currentIndex;
  final int total;
  final String title;
  final bool dark;
  final VoidCallback onClose;
  final bool isShaking;
  final AnimationController shakeValue;

  const _HudBar({
    required this.currentIndex,
    required this.total,
    required this.title,
    required this.dark,
    required this.onClose,
    required this.isShaking,
    required this.shakeValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: dark ? PremiumColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                  ),
                  child: Icon(Icons.close_rounded, size: 18, color: dark ? Colors.white54 : Colors.black54),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(width: 34),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: total > 0 ? currentIndex / total : 0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                valueColor: const AlwaysStoppedAnimation<Color>(PremiumColors.splashBlue),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
