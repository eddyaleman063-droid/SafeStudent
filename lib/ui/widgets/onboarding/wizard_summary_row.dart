import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';

class WizardSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const WizardSummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF1A1A2E).withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
