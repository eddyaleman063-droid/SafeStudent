import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/app_logger.dart';
import '../services/mercado_pago_service.dart';
import 'providers.dart';

enum PaymentMethod { whatsapp, mercadopago }

enum PaymentStatus {
  idle,
  creatingPreference,
  waitingPayment,
  confirming,
  completed,
  failed,
}

class PaymentState {
  final PaymentStatus status;
  final String? errorMessage;
  final int? pendingGems;
  final double? pendingAmount;
  final PaymentMethod? selectedMethod;
  final String? preferenceId;
  final String? initPoint;
  final int? gemsBefore;
  final int? gemsAfter;
  final Product? selectedProduct;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.errorMessage,
    this.pendingGems,
    this.pendingAmount,
    this.selectedMethod,
    this.preferenceId,
    this.initPoint,
    this.gemsBefore,
    this.gemsAfter,
    this.selectedProduct,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? errorMessage,
    int? pendingGems,
    double? pendingAmount,
    PaymentMethod? selectedMethod,
    String? preferenceId,
    String? initPoint,
    int? gemsBefore,
    int? gemsAfter,
    Product? selectedProduct,
    bool clearError = false,
  }) {
    return PaymentState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pendingGems: pendingGems ?? this.pendingGems,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      preferenceId: preferenceId ?? this.preferenceId,
      initPoint: initPoint ?? this.initPoint,
      gemsBefore: gemsBefore ?? this.gemsBefore,
      gemsAfter: gemsAfter ?? this.gemsAfter,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}

class PaymentNotifier extends Notifier<PaymentState> {
  late final MercadoPagoService _mpService;
  late final AppLogger _logger;

  @override
  PaymentState build() {
    _mpService = MercadoPagoService();
    _logger = AppLogger();
    return const PaymentState();
  }

  Future<String?> initiateMercadoPago({
    required int gems,
    required double price,
    Product? product,
  }) async {
    final authState = ref.read(authProvider);
    final userId = authState.uid;

    if (userId == null || userId.isEmpty) {
      state = state.copyWith(
        status: PaymentStatus.failed,
        errorMessage: 'Debes iniciar sesión para comprar gemas',
      );
      return null;
    }

    state = state.copyWith(
      status: PaymentStatus.creatingPreference,
      pendingGems: gems,
      pendingAmount: price,
      selectedMethod: PaymentMethod.mercadopago,
      gemsBefore: ref.read(learningProvider).gems,
      selectedProduct: product,
      clearError: true,
    );

    try {
      final pref = await _mpService.createPreference(
        gems: gems,
        userId: userId,
        productId: product?.id,
        bonuses: product?.bonuses
            .map((b) => {'type': b.type.name, 'quantity': b.quantity})
            .toList(),
        price: price,
      );

      state = state.copyWith(
        status: PaymentStatus.waitingPayment,
        preferenceId: pref.preferenceId,
        initPoint: pref.initPoint,
      );

      return pref.initPoint;
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.failed,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<void> initiateWhatsApp({
    required int gems,
    required double price,
    Product? product,
  }) async {
    state = state.copyWith(
      status: PaymentStatus.waitingPayment,
      pendingGems: gems,
      pendingAmount: price,
      selectedMethod: PaymentMethod.whatsapp,
      gemsBefore: ref.read(learningProvider).gems,
      selectedProduct: product,
      clearError: true,
    );
    // Register pending payment on server
    try {
      const opId = 'wa_whatsapp'; // simplified; real flow would use UUID
      await _mpService.registerPendingPayment(
        paymentMethod: 'whatsapp',
        operationId: opId,
        amount: gems,
        productId: product?.id,
      );
    } catch (e) {
      _logger.error('Failed to register pending payment', e);
    }
  }

  void onPaymentSuccess(String externalRef) {
    _logger.info('Payment success callback: $externalRef');

    final gemsBefore = state.gemsBefore ?? ref.read(learningProvider).gems;
    final currentGems = ref.read(learningProvider).gems;

    state = state.copyWith(
      status: PaymentStatus.completed,
      gemsAfter: currentGems > gemsBefore
          ? currentGems
          : (gemsBefore + (state.pendingGems ?? 0)),
    );
  }

  void onPaymentFailure({String? error}) {
    state = state.copyWith(
      status: PaymentStatus.failed,
      errorMessage: error ?? 'El pago fue cancelado o no se completó',
    );
  }

  void refreshGems() {
    final currentGems = ref.read(learningProvider).gems;
    state = state.copyWith(
      gemsAfter: currentGems,
      status: currentGems > (state.gemsBefore ?? 0)
          ? PaymentStatus.completed
          : state.status,
    );
  }

  void reset() {
    state = const PaymentState();
  }
}

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);
