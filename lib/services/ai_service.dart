import 'dart:async';
import '../models/chat_message.dart';
import 'gemini_api_client.dart';
import 'sage_prompt_builder.dart';

enum AiErrorType { apiKey, auth, rateLimit, timeout, server, network, invalidResponse, unknown }

class AiException implements Exception {
  final AiErrorType type;
  final String message;
  final Object? originalError;
  const AiException(this.type, this.message, {this.originalError});

  @override
  String toString() => 'AiException($type): $message';
}

abstract class AiService {
  Future<String> generate(List<ChatMessage> messages, {int retryCount = 0});
  Stream<String> generateStream(List<ChatMessage> messages, {int retryCount = 0});
  void dispose();
  bool get isAvailable;
}

class GeminiAiService implements AiService {
  final GeminiApiClient _client;
  final SagePromptBuilder _promptBuilder;

  GeminiAiService([GeminiApiClient? client])
      : _client = client ?? GeminiApiClient(),
        _promptBuilder = SagePromptBuilder() {
    _client.init();
  }

  @override
  bool get isAvailable => _client.isAvailable;

  @override
  void dispose() {
    _client.dispose();
  }

  @override
  Future<String> generate(List<ChatMessage> messages, {int retryCount = 0}) async {
    final contents = _promptBuilder.buildContents(messages);
    return _client.generate(contents, retryCount: retryCount);
  }

  @override
  Stream<String> generateStream(List<ChatMessage> messages, {int retryCount = 0}) async* {
    final contents = _promptBuilder.buildContents(messages);
    yield* _client.generateStream(contents, retryCount: retryCount);
  }
}
