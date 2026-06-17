import 'package:flutter/material.dart';
import 'package:sagen/core/theme/app_colors.dart';
import '../../../core/theme/theme_constants.dart';

class QuizOptionButton extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final bool correct;
  final bool revealed;
  final VoidCallback? onTap;
  final bool disabled;

  const QuizOptionButton({
    super.key,
    required this.index,
    required this.text,
    required this.selected,
    required this.correct,
    required this.revealed,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color? borderColor;
    Color? textColor;
    String? prefix;

    if (disabled) {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHigh;
      borderColor = Colors.transparent;
      textColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.30);
      prefix = '—';
    } else if (revealed) {
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
        bgColor = Theme.of(context).colorScheme.surfaceContainerHigh;
        borderColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
        textColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54);
      }
    } else {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHigh;
      borderColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
      textColor = context.textPrimary;
    }

    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    final label = '${letters[index]}: $text';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: Semantics(
          button: true,
          label: label,
          enabled: revealed ? false : true,
          child: InkWell(
          onTap: (revealed || disabled) ? null : onTap,
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
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
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
      ),
    );
  }
}
