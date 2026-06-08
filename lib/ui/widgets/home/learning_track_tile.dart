import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../models/learning/stage.dart';

enum StageStatus { locked, inProgress, completed }

class LearningTrackTile extends StatelessWidget {
  final Stage stage;
  final StageStatus status;
  final VoidCallback? onTap;
  final bool isLast;
  final int index;

  const LearningTrackTile({
    super.key,
    required this.stage,
    required this.status,
    this.onTap,
    this.isLast = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final completed = status == StageStatus.completed;
    final inProgress = status == StageStatus.inProgress;
    final locked = status == StageStatus.locked;

    final glowColor = inProgress
        ? PremiumColors.splashBlue
        : completed
            ? const Color(0xFFFFB300)
            : Colors.transparent;

    final tile = Opacity(
      opacity: locked ? 0.5 : 1.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
        child: GestureDetector(
          onTap: locked ? null : onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: dark ? PremiumColors.darkCard.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.9),
              border: Border.all(
                color: completed
                    ? const Color(0xFFFFB300)
                    : inProgress
                        ? PremiumColors.splashBlue
                        : dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.08),
                width: inProgress ? 1.5 : 1.0,
              ),
              boxShadow: inProgress || completed
                  ? [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.15),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    color: completed
                        ? const Color(0xFFFFB300).withValues(alpha: 0.15)
                        : inProgress
                            ? PremiumColors.splashBlue.withValues(alpha: 0.15)
                            : dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Icon(
                    locked ? Icons.lock_rounded : stage.icon,
                    size: 20,
                    color: completed
                        ? const Color(0xFFFFB300)
                        : inProgress
                            ? PremiumColors.splashBlue
                            : dark ? Colors.white38 : Colors.black38,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: completed
                              ? const Color(0xFFFFB300)
                              : dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stage.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: dark ? Colors.white.withValues(alpha: 0.4) : Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: LinearProgressIndicator(
                          value: stage.progress,
                          backgroundColor: dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            completed
                                ? const Color(0xFFFFB300)
                                : inProgress
                                    ? PremiumColors.splashBlue
                                    : Colors.white24,
                          ),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  size: 22,
                  color: completed
                      ? const Color(0xFFFFB300)
                      : dark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Hero(
      tag: 'stage_${stage.id}',
      child: tile.animate(delay: (index * 60).ms).fadeIn(
        duration: 350.ms,
        curve: Curves.easeOut,
      ).slideX(begin: 0.08, end: 0, duration: 350.ms, curve: Curves.easeOut),
    );
  }
}
