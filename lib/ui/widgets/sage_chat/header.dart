import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/sage_ai_provider.dart';

class SageChatHeader extends StatelessWidget {
  final bool dark;
  final SageAiChatState sage;
  final VoidCallback? onClear;
  const SageChatHeader({super.key, required this.dark, required this.sage, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: PremiumColors.gradientSage, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sage Tutor',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Tu guia de ciberseguridad',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          if (sage.messages.isNotEmpty && !sage.isBusy)
            GestureDetector(
              onTap: () => onClear?.call(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Limpiar', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
