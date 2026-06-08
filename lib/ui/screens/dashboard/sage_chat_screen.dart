import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/experience_service.dart';
import '../../widgets/sage_chat/locked_gatekeeper.dart';
import '../../widgets/sage_chat/header.dart';
import '../../widgets/sage_chat/message_list.dart';
import '../../widgets/sage_chat/typing_indicator.dart';
import '../../widgets/sage_chat/quick_chips.dart';
import '../../widgets/sage_chat/input_bar.dart';

class SageChatScreen extends ConsumerStatefulWidget {
  const SageChatScreen({super.key});

  @override
  ConsumerState<SageChatScreen> createState() => _SageChatScreenState();
}

class _SageChatScreenState extends ConsumerState<SageChatScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollCtrl = ScrollController();
  bool _showChips = true;

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients && mounted) {
        _scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _showChips = false;
    ExperienceService.instance.lightHaptic();
    ref.read(sageAiProvider.notifier).sendMessage(text);
    _textCtrl.clear();
    _focusNode.unfocus();
    _scrollDown();
  }

  void _onChipTap(String text) {
    ExperienceService.instance.lightHaptic();
    _showChips = false;
    ref.read(sageAiProvider.notifier).sendMessage(text);
    _scrollDown();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sageState = ref.watch(sageAiProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    if (sageState.isLocked) {
      return GestureDetector(
        onTap: () => ExperienceService.instance.errorHaptic(),
        child: LockedGatekeeper(sage: sageState, dark: dark),
      );
    }

    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              SageChatHeader(
                dark: dark,
                sage: sageState,
                onClear: () => ref.read(sageAiProvider.notifier).clearMessages(),
              ),
              Expanded(
                child: MessageList(
                  sage: sageState,
                  scrollCtrl: _scrollCtrl,
                  dark: dark,
                ),
              ),
              if (sageState.errorMessage != null)
                _ErrorBanner(message: sageState.errorMessage!, dark: dark),
              if (sageState.isLoading)
                TypingIndicator(dark: dark),
              if (_showChips && sageState.messages.isEmpty && sageState.suggestionChips.isNotEmpty)
                QuickChips(
                  chips: sageState.suggestionChips,
                  onTap: (t) => _onChipTap(t),
                  dark: dark,
                ),
              InputBar(
                controller: _textCtrl,
                focusNode: _focusNode,
                dark: dark,
                enabled: !sageState.isBusy,
                onSend: () => _send(_textCtrl.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool dark;
  const _ErrorBanner({required this.message, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      color: Colors.red.shade400.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red.shade400),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12, color: dark ? Colors.white70 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}


