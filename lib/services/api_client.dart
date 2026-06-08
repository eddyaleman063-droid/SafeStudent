import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../utils/retry.dart';

export 'package:http/http.dart' show Client;

enum ApiErrorType { timeout, network, auth, rateLimit, server, validation, unknown }

class ApiException implements Exception {
  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final String? host;

  const ApiException(this.type, this.message, {this.statusCode, this.host});

  @override
  String toString() => 'ApiException($type): $message';
}

class ApiRequest {
  final String method;
  final Uri uri;
  final Map<String, String>? headers;
  final dynamic body;
  final Duration? timeout;

  const ApiRequest({
    required this.method,
    required this.uri,
    this.headers,
    this.body,
    this.timeout,
  });

  bool get isStreaming => method == 'GET' || method == 'POST';

  String get host => uri.host;
}

class ApiResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;

  const ApiResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });

  Map<String, dynamic>? get jsonMap {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }

  List<dynamic>? get jsonList {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) return List<dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }
}

class ApiClient {
  static ApiClient? _instance;

  final http.Client _client = http.Client();

  final RetryConfig _defaultRetryConfig;

  ApiClient._({
    RetryConfig? retryConfig,
  }) : _defaultRetryConfig = retryConfig ?? const RetryConfig(
          maxRetries: 2,
          baseDelay: Duration(seconds: 1),
          policy: RetryPolicy.exponentialBackoff,
        );

  static Future<ApiClient> init({
    RetryConfig? retryConfig,
  }) async {
    final client = ApiClient._(retryConfig: retryConfig);
    _instance = client;
    return client;
  }

  static ApiClient get instance {
    if (_instance == null) {
      throw StateError('ApiClient not initialized. Call ApiClient.init() first.');
    }
    return _instance!;
  }

  Future<ApiResponse> send(ApiRequest request) async {
    _validateRequest(request);

    return retry(
      () => _execute(request),
      config: RetryConfig(
        maxRetries: _defaultRetryConfig.maxRetries,
        baseDelay: _defaultRetryConfig.baseDelay,
        policy: _defaultRetryConfig.policy,
        shouldRetry: (e) => e is ApiException && _shouldRetry(e),
      ),
    );
  }

  Stream<String> sendStreaming(ApiRequest request) async* {
    _validateRequest(request);

    final effectiveTimeout = request.timeout ?? AppConfig.defaultTimeout;
    final httpReq = http.Request(request.method, request.uri);
    if (request.headers != null) httpReq.headers.addAll(request.headers!);
    if (request.body != null) {
      if (request.body is String) {
        httpReq.body = request.body as String;
      } else if (request.body is Map) {
        httpReq.body = jsonEncode(request.body);
        httpReq.headers['Content-Type'] = 'application/json';
      }
    }

    late http.StreamedResponse response;
    try {
      response = await _client.send(httpReq).timeout(effectiveTimeout);
    } on TimeoutException {
      throw const ApiException(ApiErrorType.timeout, 'La respuesta tardó demasiado.');
    } on SocketException {
      throw const ApiException(ApiErrorType.network, 'Sin conexión a internet.');
    } on Exception catch (e) {
      throw ApiException(ApiErrorType.network, e.toString());
    }

    _checkHttpStatus(response.statusCode);

    try {
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        yield chunk;
      }
    } on Exception catch (e) {
      throw ApiException(ApiErrorType.network, 'Error en streaming: $e');
    }
  }

  Future<ApiResponse> _execute(ApiRequest request) async {
    final effectiveTimeout = request.timeout ?? AppConfig.defaultTimeout;
    final uri = request.uri;
    final headers = Map<String, String>.from(request.headers ?? {});

    try {
      http.Response response;

      switch (request.method.toUpperCase()) {
        case 'GET':
          response = await _client.get(uri, headers: headers).timeout(effectiveTimeout);
          break;
        case 'POST':
          if (request.body is Map && !headers.containsKey('Content-Type')) {
            headers['Content-Type'] = 'application/json';
          }
          final body = request.body is Map ? jsonEncode(request.body) : (request.body as String? ?? '');
          response = await _client.post(uri, headers: headers, body: body).timeout(effectiveTimeout);
          break;
        default:
          throw ApiException(ApiErrorType.validation, 'Método no soportado: ${request.method}');
      }

      return ApiResponse(
        statusCode: response.statusCode,
        body: response.body,
        headers: response.headers,
      );
    } on TimeoutException {
      throw ApiException(ApiErrorType.timeout, 'La respuesta tardó demasiado.', host: request.host);
    } on SocketException {
      throw ApiException(ApiErrorType.network, 'Sin conexión a internet.', host: request.host);
    } on http.ClientException catch (e) {
      throw ApiException(ApiErrorType.network, e.message, host: request.host);
    }
  }

  void _validateRequest(ApiRequest request) {
    if (request.uri.scheme != 'https') {
      throw const ApiException(ApiErrorType.validation, 'Solo se permiten conexiones HTTPS.');
    }
    if (request.uri.host.isEmpty) {
      throw const ApiException(ApiErrorType.validation, 'URL inválida.');
    }
  }

  bool _shouldRetry(ApiException e) {
    switch (e.type) {
      case ApiErrorType.rateLimit:
      case ApiErrorType.server:
      case ApiErrorType.timeout:
      case ApiErrorType.network:
        return true;
      case ApiErrorType.auth:
      case ApiErrorType.validation:
      case ApiErrorType.unknown:
        return false;
    }
  }

  static void _checkHttpStatus(int statusCode) {
    if (statusCode == 401) {
      throw const ApiException(ApiErrorType.auth, 'Error de autenticación.');
    }
    if (statusCode == 403) {
      throw const ApiException(ApiErrorType.auth, 'Acceso denegado.');
    }
    if (statusCode == 429) {
      throw const ApiException(ApiErrorType.rateLimit, 'Demasiadas solicitudes. Espera unos segundos.');
    }
    if (statusCode >= 500) {
      throw ApiException(ApiErrorType.server, 'Error del servidor ($statusCode).', statusCode: statusCode);
    }
    if (statusCode != 200) {
      throw ApiException(ApiErrorType.unknown, 'Error inesperado ($statusCode).', statusCode: statusCode);
    }
  }

  void dispose() {
    _client.close();
    _instance = null;
  }
}