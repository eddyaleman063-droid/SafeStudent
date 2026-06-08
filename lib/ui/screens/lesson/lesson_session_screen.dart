import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';

class LessonSessionScreen extends ConsumerStatefulWidget {
  final String stageId;
  final String lessonId;
  final String lessonTitle;
  const LessonSessionScreen({
    super.key,
    required this.stageId,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  ConsumerState<LessonSessionScreen> createState() => _LessonSessionScreenState();
}

class _LessonSessionScreenState extends ConsumerState<LessonSessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  bool _navigatedToResults = false;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionProvider.notifier).startSession(widget.stageId, widget.lessonId);
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  void _triggerSlide() {
    _slideCtrl.reset();
    _slideCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final session = ref.watch(sessionProvider);

    if (session.phase == SessionPhase.completed && !_navigatedToResults) {
      _navigatedToResults = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed(
            'lesson-results',
            pathParameters: {
              'stageId': widget.stageId,
              'lessonId': widget.lessonId,
            },
          );
        }
      });
    }

    if (session.phase == SessionPhase.gameOver) {
      return _GameOverOverlay(dark: dark, session: session);
    }

    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            _HudBar(session: session, dark: dark, title: widget.lessonTitle),
            if (session.phase == SessionPhase.feedback)
              Expanded(child: _FeedbackBody(session: session, dark: dark, onContinue: _triggerSlide))
            else
              Expanded(child: _QuestionBody(session: session, dark: dark, animController: _slideCtrl, slideAnim: _slideAnim)),
            _BottomBar(session: session, dark: dark),
          ],
        ),
      ),
    );
  }
}

class _HudBar extends StatelessWidget {
  final SessionState session;
  final bool dark;
  final String title;
  const _HudBar({required this.session, required this.dark, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: dark ? PremiumColors.darkCard : Colors.white,
        boxShadow: AppShadows.card(color: dark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close_rounded, color: dark ? Colors.white54 : Colors.black54),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark ? Colors.white.withValues(alpha: 0.8) : Colors.black87,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final filled = i < session.lives;
                  return Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 18,
                      color: filled
                          ? Colors.red.shade400
                          : (dark ? Colors.white24 : Colors.black12),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: session.progress,
              backgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(
                session.lives <= 1 ? Colors.red.shade400 : PremiumColors.primaryAccent,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionBody extends ConsumerWidget {
  final SessionState session;
  final bool dark;
  final AnimationController animController;
  final Animation<Offset> slideAnim;
  const _QuestionBody({
    required this.session,
    required this.dark,
    required this.animController,
    required this.slideAnim,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final challenge = session.currentChallenge;
    if (challenge == null) {
      return Center(child: Text(l.sessionLoading));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (animController.value == 0) animController.forward();
    });

    return SlideTransition(
      position: slideAnim,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              challenge.question,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            ...challenge.options.asMap().entries.map((entry) {
              final i = entry.key;
              final opt = entry.value;
              final selected = session.feedbackSelected == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _OptionTile(
                  index: i,
                  text: opt,
                  selected: selected,
                  dark: dark,
                  onTap: () => ref.read(sessionProvider.notifier).submitAnswer(i),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final bool dark;
  final VoidCallback onTap;
  const _OptionTile({
    required this.index,
    required this.text,
    required this.selected,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D'];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: selected
              ? PremiumColors.primaryAccent.withValues(alpha: 0.12)
              : (dark ? PremiumColors.darkCard : Colors.white),
          border: Border.all(
            color: selected
                ? PremiumColors.primaryAccent.withValues(alpha: 0.4)
                : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? PremiumColors.primaryAccent
                    : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.04)),
              ),
              child: Center(
                child: Text(
                  letters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : (dark ? Colors.white54 : Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  final SessionState session;
  final bool dark;
  const _BottomBar({required this.session, required this.dark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final isFeedback = session.phase == SessionPhase.feedback;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, AppSpacing.xxl),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isFeedback
              ? () => ref.read(sessionProvider.notifier).nextQuestion()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFeedback ? PremiumColors.primary : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.04)),
            disabledBackgroundColor: dark ? Colors.white12 : Colors.black.withValues(alpha: 0.04),
            foregroundColor: Colors.white,
            disabledForegroundColor: dark ? Colors.white24 : Colors.black26,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            elevation: 0,
          ),
          child: Text(
            isFeedback ? l.nextText : l.sessionSelectAnswer,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _FeedbackBody extends StatelessWidget {
  final SessionState session;
  final bool dark;
  final VoidCallback onContinue;
  const _FeedbackBody({required this.session, required this.dark, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final correct = session.feedbackCorrect;
    final challenge = session.currentChallenge!;
    final correctOption = challenge.options[challenge.correctIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              color: (correct ? PremiumColors.success : Colors.red.shade400).withValues(alpha: 0.08),
              border: Border.all(
                color: (correct ? PremiumColors.success : Colors.red.shade400).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 48,
                  color: correct ? PremiumColors.success : Colors.red.shade400,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  correct ? l.sessionCorrect : l.sessionIncorrect,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: correct ? PremiumColors.success : Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (!correct) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      color: PremiumColors.success.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      l.sessionCorrectAnswer(correctOption),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: PremiumColors.success),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text(
                  challenge.explanation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: dark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
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

class _GameOverOverlay extends ConsumerWidget {
  final bool dark;
  final SessionState session;
  const _GameOverOverlay({required this.dark, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty_rounded, size: 64, color: Colors.red.shade400.withValues(alpha: 0.6)),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l.sessionLivesExhausted,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.sessionLivesExhaustedDesc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: dark ? Colors.white38 : Colors.black45),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l.sessionScore(session.correctCount, session.totalQuestions),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PremiumColors.primaryAccent,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(sessionProvider.notifier).retry();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                  ),
                  child: Text(l.sessionRetry, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l.sessionBackToMap,
                  style: TextStyle(color: dark ? Colors.white38 : Colors.black38, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
