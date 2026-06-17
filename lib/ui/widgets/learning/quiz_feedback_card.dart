import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../l10n/app_localizations.dart';

class QuizFeedbackCard extends StatelessWidget {
  final bool correct;
  final String explanation;

  const QuizFeedbackCard({
    super.key,
    required this.correct,
    required this.explanation,
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
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
