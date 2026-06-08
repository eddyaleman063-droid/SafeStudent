import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/widgets/gem_pile_widget.dart';
import 'package:sagen/ui/widgets/gem_widget.dart';
import 'package:sagen/ui/widgets/animations/gem_rain_animation.dart';
import 'package:sagen/ui/widgets/learning/quiz_session.dart';
import 'package:sagen/ui/widgets/streak/flame_animation_widget.dart';

class QuizSummaryScreen extends StatefulWidget {
  final QuizResult result;
  final VoidCallback onContinue;
  final VoidCallback? onRetry;

  const QuizSummaryScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onRetry,
  });

  @override
  State<QuizSummaryScreen> createState() => _QuizSummaryScreenState();
}

class _QuizSummaryScreenState extends State<QuizSummaryScreen> {
  bool _showRain = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _showRain = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scorePercent = (widget.result.score * 100).round();
    final minutes = widget.result.timeTaken.inMinutes;
    final seconds = widget.result.timeTaken.inSeconds % 60;
    final r = widget.result;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: FlameAnimationWidget(phase: null),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: r.perfect
                          ? const LinearGradient(
                              colors: [PremiumColors.achievementStart, PremiumColors.achievementEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : r.score >= 0.7
                              ? const LinearGradient(
                                  colors: [PremiumColors.primary, PremiumColors.primaryLight],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [Colors.grey.shade400, Colors.grey.shade300],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                      boxShadow: [
                        BoxShadow(
                          color: (r.perfect
                                  ? PremiumColors.achievementEnd
                                  : PremiumColors.primary)
                              .withValues(alpha: 0.3),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$scorePercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    r.perfect
                        ? l.summaryPerfect
                        : r.score >= 0.7
                            ? l.summaryGoodWork
                            : l.summaryKeepPracticing,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.correctAnswers(r.correctAnswers, r.totalQuestions),
                    style: TextStyle(
                      fontSize: 14,
                      color: dark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  if (minutes > 0 || seconds > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${minutes}m ${seconds}s',
                        style: TextStyle(
                          fontSize: 12,
                          color: dark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  if (_showRain) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: GemRainAnimation(
                        gemCount: r.gemsEarned.clamp(5, 20),
                        totalGems: r.gemsEarned,
                        height: 80,
                      ),
                    ),
                    if (r.gemsEarned > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GemPileWidget(
                          gemCount: r.gemsEarned.clamp(1, 30),
                          maxSize: 60 + r.gemsEarned.clamp(0, 20) * 2,
                          itemSize: 14,
                        ),
                      ),
                  ],
                  const SizedBox(height: 32),
                  _RewardRow(
                    iconWidget: const Icon(Icons.auto_awesome_rounded, size: 18, color: PremiumColors.achievementEnd),
                    label: l.summaryXpEarned,
                    value: '${r.xpEarned}',
                    color: PremiumColors.achievementEnd,
                    dark: dark,
                  ),
                  const SizedBox(height: 12),
                  _RewardRow(
                    iconWidget: const GemWidget(size: 18, animate: false),
                    label: l.summaryGemsEarned,
                    value: '${r.gemsEarned}',
                    color: PremiumColors.premiumBlue,
                    dark: dark,
                  ),
                  const SizedBox(height: 12),
                  _RewardRow(
                    iconWidget: const Icon(Icons.emoji_events_rounded, size: 18, color: PremiumColors.achievementEnd),
                    label: l.profileStreak,
                    value: l.summaryStreakDays(r.perfect ? 2 : 1),
                    color: PremiumColors.achievementEnd,
                    dark: dark,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: widget.onContinue,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      label: Text(l.continueText,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PremiumColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: PremiumColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  if (widget.onRetry != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: widget.onRetry,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(l.sessionRetry,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PremiumColors.primary,
                          side: BorderSide(
                            color: PremiumColors.primary.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;
  final Color color;
  final bool dark;

  const _RewardRow({
    required this.iconWidget,
    required this.label,
    required this.value,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: iconWidget,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: dark ? Colors.white70 : Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
