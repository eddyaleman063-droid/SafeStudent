import 'package:flutter/material.dart';
import '../../../../ui/widgets/common/sage_emotion_widget.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/sage_emotion_service.dart';

class WizardSageSection extends StatelessWidget {
  final SageEmotion emotion;
  final String message;
  final bool isDark;

  const WizardSageSection({
    super.key,
    required this.emotion,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RepaintBoundary(
            child: SageEmotionWidget(
              emotion: emotion,
              size: 52,
              animated: true,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
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

class WizardSageBubble extends StatelessWidget {
  final String message;
  final bool isDark;

  const WizardSageBubble({super.key, required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6D00).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: const Color(0xFFFF6D00).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 20,
            color: const Color(0xFFFF6D00).withValues(alpha: 0.8),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
