import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool dark;
  final bool enabled;
  final VoidCallback onSend;
  const InputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.dark,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: dark ? PremiumColors.darkSurface : Colors.white,
        border: Border(top: BorderSide(color: dark ? Colors.white12 : Colors.black.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              textInputAction: TextInputAction.send,
              onSubmitted: enabled ? (_) => onSend() : null,
              decoration: InputDecoration(
                hintText: 'Pregunta a Sage...',
                hintStyle: TextStyle(fontSize: 14, color: dark ? Colors.white24 : Colors.black26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: enabled
                  ? const LinearGradient(colors: PremiumColors.gradientSage)
                  : null,
              color: enabled ? null : (dark ? Colors.white10 : Colors.black12),
            ),
            child: IconButton(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send_rounded, size: 18),
              color: enabled ? Colors.white : (dark ? Colors.white24 : Colors.black26),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
