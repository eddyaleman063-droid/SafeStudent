import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../config/app_config.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/app_logger.dart';
import '../../widgets/common/sagen_notification.dart';

class GemCreditingService {
  final String _baseUrl = AppConfig.mercadopagoFunctionsUrl;
  final _logger = AppLogger();

  Future<bool> creditGems({
    required String userId,
    required int gems,
    required String paymentMethod,
  }) async {
    final url = Uri.parse('$_baseUrl/api/adminCreditGems');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _logger.error('adminCreditGems: no authenticated user');
        return false;
      }
      final idToken = await user.getIdToken();
      final key = '$userId|$gems|${DateTime.now().millisecondsSinceEpoch}';
      final idempotencyKey = sha256.convert(utf8.encode(key)).toString();

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: jsonEncode({
              'userId': userId,
              'gems': gems,
              'paymentMethod': paymentMethod,
              'idempotencyKey': idempotencyKey,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        _logger.error('adminCreditGems failed', {
          'status': response.statusCode,
          'body': response.body,
        });
        return false;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final result = decoded['result'] as Map<String, dynamic>?;
      return result?['success'] == true;
    } catch (e) {
      _logger.error('adminCreditGems error', e);
      return false;
    }
  }
}

class AdminCreditScreen extends StatefulWidget {
  const AdminCreditScreen({super.key});

  @override
  State<AdminCreditScreen> createState() => _AdminCreditScreenState();
}

class _AdminCreditScreenState extends State<AdminCreditScreen> {
  final _userIdController = TextEditingController();
  final _gemsController = TextEditingController();
  final _service = GemCreditingService();
  bool _loading = false;
  String _method = 'whatsapp';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final token = await user.getIdTokenResult();
    setState(() => _isAdmin = token.claims?['admin'] == true);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _gemsController.dispose();
    super.dispose();
  }

  Future<void> _credit() async {
    final userId = _userIdController.text.trim();
    final gems = int.tryParse(_gemsController.text.trim());

    if (userId.isEmpty || gems == null || gems <= 0) {
      if (!mounted) return;
      SagenNotification.show(
        context,
        message: 'Ingresa un User ID válido y cantidad de gemas',
        type: NotificationType.error,
      );
      return;
    }

    setState(() => _loading = true);

    final ok = await _service.creditGems(
      userId: userId,
      gems: gems,
      paymentMethod: _method,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      SagenNotification.show(context, message: '$gems gemas acreditadas a $userId');
      _userIdController.clear();
      _gemsController.clear();
    } else {
      SagenNotification.show(
        context,
        message: 'Error al acreditar. Verifica que tu usuario esté en la colección "admins" de Firestore.',
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin — Acreditar Gemas')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isAdmin)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  'Verificando permisos de administrador…',
                  style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                ),
              ),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _gemsController,
              decoration: const InputDecoration(labelText: 'Gemas'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Método de pago'),
              items: const [
                DropdownMenuItem(value: 'whatsapp', child: Text('WhatsApp / Yape / Plin')),
                DropdownMenuItem(value: 'mercadopago', child: Text('Mercado Pago')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _method = v);
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _loading ? null : _credit,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Acreditar Gemas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
