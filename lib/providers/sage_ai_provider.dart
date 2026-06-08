import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../models/chat_message.dart';
import '../models/sage_personality_profile.dart';
import '../services/ai_service.dart';
import '../services/local_fallback_service.dart';
import 'learning_provider.dart';
import 'service_providers.dart';

enum SageAiChatStatus { idle, loading, streaming, error }

class SageAiChatState {
  final List<ChatMessage> messages;
  final SageAiChatStatus status;
  final String streamingText;
  final String? errorMessage;
  final String userName;
  final int userLevel;
  final int currentStreak;
  final int lessonsCompleted;

  const SageAiChatState({
    this.messages = const [],
    this.status = SageAiChatStatus.idle,
    this.streamingText = '',
    this.errorMessage,
    this.userName = '',
    this.userLevel = 1,
    this.currentStreak = 0,
    this.lessonsCompleted = 0,
  });

  SageAiChatState copyWith({
    List<ChatMessage> Function()? messages,
    SageAiChatStatus? status,
    String? streamingText,
    String? Function()? errorMessage,
    String? userName,
    int? userLevel,
    int? currentStreak,
    int? lessonsCompleted,
  }) {
    return SageAiChatState(
      messages: messages != null ? messages() : this.messages,
      status: status ?? this.status,
      streamingText: streamingText ?? this.streamingText,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      userName: userName ?? this.userName,
      userLevel: userLevel ?? this.userLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
    );
  }

  bool get isLocked => lessonsCompleted < 10;
  int get lessonsRequired => 10;
  double get progress => (lessonsCompleted / lessonsRequired).clamp(0.0, 1.0);
  bool get isLoading => status == SageAiChatStatus.loading;
  bool get isStreaming => status == SageAiChatStatus.streaming;
  bool get isBusy => status == SageAiChatStatus.loading || status == SageAiChatStatus.streaming;

  List<String> get suggestionChips => [
    '¿Qué es el phishing?',
    'Crea una contraseña segura',
    'Identifica una estafa',
  ];
}

class SageAiNotifier extends Notifier<SageAiChatState> {
  late final AiService _primaryService;
  late final LocalFallbackService _fallbackService;
  StreamSubscription<String>? _streamSub;

  DateTime _lastSendTime = DateTime.now().subtract(const Duration(seconds: 5));
  static const Duration _throttleDuration = Duration(milliseconds: 1500);

  @override
  SageAiChatState build() {
    _primaryService = ref.watch(aiServiceProvider);
    _fallbackService = LocalFallbackService();
    final learning = ref.watch(learningProvider);
    ref.onDispose(() {
      _streamSub?.cancel();
      _primaryService.dispose();
      _fallbackService.dispose();
    });
    return SageAiChatState(
      lessonsCompleted: learning.lessonsCompleted,
      userLevel: learning.currentLevel,
    );
  }

  void updateContext({String userName = '', int userLevel = 1, int currentStreak = 0}) {
    state = state.copyWith(
      userName: userName,
      userLevel: userLevel,
      currentStreak: currentStreak,
    );
  }

  Future<void> sendMessage(String text) async {
    if (state.isLocked || text.trim().isEmpty || state.isBusy) return;
    if (DateTime.now().difference(_lastSendTime) < _throttleDuration) return;
    _lastSendTime = DateTime.now();

    final userMsg = ChatMessage(role: ChatRole.user, text: text, time: DateTime.now());
    final assistantMsg = ChatMessage(role: ChatRole.assistant, text: '', time: DateTime.now());

    state = state.copyWith(
      messages: () => [...state.messages, userMsg, assistantMsg],
      status: SageAiChatStatus.loading,
      streamingText: '',
      errorMessage: () => null,
    );

    final contextMessages = _buildContextMessages(text);
    final service = _primaryService.isAvailable ? _primaryService : _fallbackService;

    _streamSub = service.generateStream(contextMessages).listen(
      (chunk) {
        if (state.status == SageAiChatStatus.loading) {
          state = state.copyWith(status: SageAiChatStatus.streaming);
        }
        state = state.copyWith(streamingText: state.streamingText + chunk);
      },
      onDone: () {
        _finalizeResponse(text);
      },
      onError: (Object e) {
        ref.read(loggerProvider).error('SageAiProvider stream error', e);
        _fallbackResponse(text);
      },
    );
  }

  void _finalizeResponse(String lastQuestion) {
    final finalText = state.streamingText.trim();
    if (finalText.isEmpty && state.messages.length >= 2) {
      _fallbackResponse(lastQuestion);
      return;
    }
    _applyAssistantMessage(finalText);
  }

  void _fallbackResponse(String lastQuestion) {
    _streamSub?.cancel();
    _streamSub = null;

    state = state.copyWith(status: SageAiChatStatus.loading);

    _streamSub = _fallbackService
        .generateStream([ChatMessage(role: ChatRole.user, text: lastQuestion, time: DateTime.now())])
        .listen(
      (chunk) {
        if (state.status == SageAiChatStatus.loading) {
          state = state.copyWith(status: SageAiChatStatus.streaming);
        }
        state = state.copyWith(streamingText: state.streamingText + chunk);
      },
      onDone: () {
        _applyAssistantMessage(state.streamingText.trim());
      },
      onError: (_) {
        _applyAssistantMessage(
          'Mi conexión mental está débil ahora, pero sigue practicando y vuelve a preguntarme más tarde.',
        );
      },
    );
  }

  void _applyAssistantMessage(String text) {
    _streamSub?.cancel();
    _streamSub = null;
    final messages = List<ChatMessage>.from(state.messages);
    final idx = messages.length - 1;
    if (idx >= 0 && messages[idx].role == ChatRole.assistant) {
      messages[idx] = ChatMessage(
        role: ChatRole.assistant,
        text: text,
        time: messages[idx].time,
      );
    }
    state = state.copyWith(
      messages: () => messages,
      streamingText: '',
      errorMessage: () => null,
      status: SageAiChatStatus.idle,
    );
  }

  List<ChatMessage> _buildContextMessages(String currentText) {
    final systemContent = SagePersonalityProfile.getSystemPrompt(
      userName: state.userName,
      userLevel: state.userLevel,
      currentStreak: state.currentStreak,
    );
    final systemMsg = ChatMessage(role: ChatRole.assistant, text: systemContent, time: DateTime.now());
    final userMsg = ChatMessage(role: ChatRole.user, text: currentText, time: DateTime.now());

    final recent = <ChatMessage>[systemMsg];
    final start = state.messages.length > AppConfig.maxContextMessages * 2
        ? state.messages.length - AppConfig.maxContextMessages * 2
        : 0;
    for (int i = start; i < state.messages.length - 1; i++) {
      recent.add(state.messages[i]);
    }
    recent.add(userMsg);
    return recent;
  }

  void clearMessages() {
    _streamSub?.cancel();
    _streamSub = null;
    state = state.copyWith(
      messages: () => [],
      streamingText: '',
      errorMessage: () => null,
      status: SageAiChatStatus.idle,
    );
  }


}
