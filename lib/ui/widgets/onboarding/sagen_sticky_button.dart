import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/ui/widgets/common/sagen_touch_response.dart';

class SagenStickyButton extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const SagenStickyButton({
    super.key,
    required this.label,
    this.isEnabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && onPressed != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: SagenTouchResponse(
          onTap: enabled ? onPressed : null,
          enabled: enabled,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppEasing.standard,
            height: 56,
            decoration: BoxDecoration(
              color: enabled
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF374151),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: enabled
                  ? const Border(
                      bottom: BorderSide(
                        color: Color(0xFF16A34A),
                        width: 4,
                      ),
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: enabled ? Colors.white : const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
