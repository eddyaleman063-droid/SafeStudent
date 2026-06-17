import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'app_logger.dart';

class MercadoPagoPreference {
  final String preferenceId;
  final String initPoint;
  final String externalRef;

  const MercadoPagoPreference({
    required this.preferenceId,
    required this.initPoint,
    required this.externalRef,
  });
}

class MercadoPagoService {
  MercadoPagoService() : _logger = AppLogger();
  final AppLogger _logger;

  String get _baseUrl => AppConfig.mercadopagoFunctionsUrl;

  Future<MercadoPagoPreference> createPreference({
    required int gems,
    required String userId,
    String? productId,
    List<Map<String, dynamic>>? bonuses,
    double? price,
  }) async {
    final url = Uri.parse('$_baseUrl/api/createPaymentPreference');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'gems': gems,
              'userId': userId,
              'productId': productId,
              'bonuses': bonuses,
              'price': price,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        _logger.error('MP createPreference failed', {
          'status': response.statusCode,
          'body': response.body,
        });
        throw MercadoPagoException(
          'Error al conectar con el servicio de pagos (${response.statusCode})',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final result = decoded['result'] as Map<String, dynamic>?;

      if (result == null) {
        _logger.error('MP createPreference: no result', decoded);
        throw const MercadoPagoException('Respuesta inválida del servidor');
      }

      return MercadoPagoPreference(
        preferenceId: result['preferenceId'] as String,
        initPoint: result['initPoint'] as String,
        externalRef: result['externalRef'] as String,
      );
    } on MercadoPagoException {
      rethrow;
    } catch (e) {
      _logger.error('MP createPreference network error', e);
      throw const MercadoPagoException(
        'No se pudo conectar con el servicio de pagos. '
        'Verifica tu conexión a internet.',
      );
    }
  }

  Future<bool> checkHealth() async {
    try {
      final url = Uri.parse('$_baseUrl/api/health');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> registerPendingPayment({
    required String paymentMethod,
    required String operationId,
    int? amount,
    String? productId,
  }) async {
    final url = Uri.parse('$_baseUrl/api/registerPendingPayment');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'paymentMethod': paymentMethod,
              'operationId': operationId,
              'amount': amount,
              'productId': productId,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        _logger.error('registerPendingPayment failed', {
          'status': response.statusCode,
          'body': response.body,
        });
        throw const MercadoPagoException(
          'Error al registrar el pago pendiente',
        );
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['result'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.error('registerPendingPayment error', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validatePurchase({
    required int cost,
    required String itemId,
  }) async {
    final url = Uri.parse('$_baseUrl/api/validatePurchase');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'cost': cost, 'itemId': itemId,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        _logger.error('validatePurchase failed', {
          'status': response.statusCode,
          'body': response.body,
        });
        throw const MercadoPagoException('Error al validar la compra');
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['result'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.error('validatePurchase error', e);
      rethrow;
    }
  }
}

class MercadoPagoException implements Exception {
  final String message;
  const MercadoPagoException(this.message);

  @override
  String toString() => message;
}
