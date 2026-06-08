import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;
  final bool dark;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: PremiumColors.gradientSage),
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? AppRadius.xl : AppRadius.sm),
                  topRight: const Radius.circular(AppRadius.xl),
                  bottomLeft: const Radius.circular(AppRadius.xl),
                  bottomRight: Radius.circular(isUser ? AppRadius.sm : AppRadius.xl),
                ),
                gradient: isUser
                    ? const LinearGradient(colors: PremiumColors.gradientSage, begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                color: isUser
                    ? null
                    : (dark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? Colors.white : (dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87),
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }
}
