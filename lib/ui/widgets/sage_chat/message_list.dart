import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/models/chat_message.dart';
import 'package:sagen/providers/sage_ai_provider.dart';
import 'empty_chat.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  final SageAiChatState sage;
  final ScrollController scrollCtrl;
  final bool dark;
  const MessageList({super.key, required this.sage, required this.scrollCtrl, required this.dark});

  @override
  Widget build(BuildContext context) {
    final messages = sage.messages;

    if (messages.isEmpty) {
      return EmptyChat(dark: dark);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(0,
            duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      }
    });

    final showStreaming = sage.isStreaming && sage.streamingText.isNotEmpty;
    final extraItem = showStreaming ? 1 : 0;

    return RepaintBoundary(
      child: ListView.builder(
        controller: scrollCtrl,
        reverse: true,
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.md),
        itemCount: messages.length + extraItem,
        itemBuilder: (_, i) {
          if (showStreaming && i == 0) {
            return MessageBubble(
              message: ChatMessage(
                role: ChatRole.assistant,
                text: sage.streamingText,
                time: DateTime.now(),
              ),
              isUser: false,
              dark: dark,
            );
          }
          final idx = showStreaming ? i - 1 : i;
          if (idx >= messages.length) return const SizedBox.shrink();
          final msg = messages[messages.length - 1 - idx];
          final isUser = msg.role == ChatRole.user;

          return MessageBubble(
            message: msg,
            isUser: isUser,
            dark: dark,
          );
        },
      ),
    );
  }
}
