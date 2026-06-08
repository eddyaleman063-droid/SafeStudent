import 'dart:async';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/app_config.dart';
import 'ai_service.dart';
import 'app_logger.dart';
import 'sage_prompt_builder.dart';

class GeminiApiClient {
  final AppLogger _logger;
  GenerativeModel? _model;
  final SagePromptBuilder _promptBuilder = SagePromptBuilder();
  final Random _jitter = Random();

  GeminiApiClient({AppLogger? logger}) : _logger = logger ?? AppLogger();

  bool get isAvailable => _model != null;

  int get _maxRetries => AppConfig.geminiMaxRetries;

  void init() {
    const apiKey = AppConfig.geminiApiKey;
    if (apiKey.isEmpty) {
      _logger.warning('GeminiApiClient: GEMINI_API_KEY not set');
      return;
    }
    _model = GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: AppConfig.geminiMaxOutputTokens,
        temperature: AppConfig.geminiTemperature,
        topK: AppConfig.geminiTopK,
        topP: AppConfig.geminiTopP,
      ),
      systemInstruction: _promptBuilder.buildSystemInstruction(),
    );
    _logger.info('GeminiApiClient: initialized with ${AppConfig.geminiModel}');
  }

  Future<String> generate(List<Content> contents, {int retryCount = 0}) async {
    if (_model == null) {
      throw const AiException(
        AiErrorType.apiKey,
        'Gemini no está configurado. Agrega GEMINI_API_KEY al lanzar la app.',
      );
    }

    try {
      final response = await _model!
          .generateContent(contents)
          .timeout(AppConfig.geminiTimeout);
      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        throw const AiException(
          AiErrorType.invalidResponse,
          'Gemini devolvió una respuesta vacía.',
        );
      }
      return text;
    } on TimeoutException {
      throw const AiException(
        AiErrorType.timeout,
        'Gemini tardó demasiado en responder.',
      );
    } on AiException {
      rethrow;
    } on GenerativeAIException catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        final base = AppConfig.geminiRetryDelay * (retryCount + 1);
        final jitter = Duration(milliseconds: _jitter.nextInt(1000));
        await Future.delayed(base + jitter);
        return generate(contents, retryCount: retryCount + 1);
      }
      throw _mapGenerativeError(e);
    } catch (e) {
      throw AiException(
        AiErrorType.unknown,
        'Error inesperado al contactar a Gemini.',
        originalError: e,
      );
    }
  }

  Stream<String> generateStream(List<Content> contents, {int retryCount = 0}) async* {
    if (_model == null) {
      throw const AiException(
        AiErrorType.apiKey,
        'Gemini no está configurado. Agrega GEMINI_API_KEY al lanzar la app.',
      );
    }

    Stream<String> stream;
    try {
      stream = _model!
          .generateContentStream(contents)
          .timeout(AppConfig.geminiStreamTimeout)
          .map((response) => response.text ?? '');
    } on TimeoutException {
      throw const AiException(
        AiErrorType.timeout,
        'Gemini tardó demasiado en responder.',
      );
    } on GenerativeAIException catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        final base = AppConfig.geminiRetryDelay * (retryCount + 1);
        final jitter = Duration(milliseconds: _jitter.nextInt(1000));
        await Future.delayed(base + jitter);
        yield* generateStream(contents, retryCount: retryCount + 1);
        return;
      }
      throw _mapGenerativeError(e);
    } catch (e) {
      throw AiException(
        AiErrorType.unknown,
        'Error inesperado en streaming.',
        originalError: e,
      );
    }

    bool receivedContent = false;
    try {
      await for (final chunk in stream) {
        if (chunk.isNotEmpty) {
          receivedContent = true;
          yield chunk;
        }
      }
      if (!receivedContent) {
        throw const AiException(
          AiErrorType.invalidResponse,
          'Gemini no generó contenido.',
        );
      }
    } on AiException {
      rethrow;
    } on TimeoutException {
      throw const AiException(
        AiErrorType.timeout,
        'Gemini tardó demasiado en responder.',
      );
    } on GenerativeAIException catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        final base = AppConfig.geminiRetryDelay * (retryCount + 1);
        final jitter = Duration(milliseconds: _jitter.nextInt(1000));
        await Future.delayed(base + jitter);
        yield* generateStream(contents, retryCount: retryCount + 1);
        return;
      }
      throw _mapGenerativeError(e);
    } catch (e) {
      throw AiException(
        AiErrorType.unknown,
        'Error inesperado en streaming.',
        originalError: e,
      );
    }
  }

  void dispose() {
    _model = null;
  }

  bool _shouldRetry(GenerativeAIException e) => e is ServerException;

  AiException _mapGenerativeError(GenerativeAIException e) {
    if (e is InvalidApiKey) {
      return const AiException(
        AiErrorType.auth,
        'La API key de Gemini no es válida. Verifica que GEMINI_API_KEY sea correcta.',
      );
    }
    if (e is ServerException) {
      return const AiException(
        AiErrorType.server,
        'El servidor de Gemini no está disponible momentáneamente.',
      );
    }
    if (e is UnsupportedUserLocation) {
      return const AiException(
        AiErrorType.auth,
        'Tu ubicación no es compatible con la API de Gemini.',
      );
    }
    if (e is GenerativeAISdkException) {
      return AiException(
        AiErrorType.unknown,
        'Error interno del SDK de Gemini: ${e.message}',
        originalError: e,
      );
    }
    return AiException(
      AiErrorType.unknown,
      'Error de Gemini: ${e.message}',
      originalError: e,
    );
  }
}
