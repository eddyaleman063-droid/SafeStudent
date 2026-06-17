import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/providers/payment_provider.dart';
import 'package:sagen/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/mock_learning_provider.dart';

void main() {
  group('PaymentState', () {
    test('initial state has correct defaults', () {
      const state = PaymentState();
      expect(state.status, PaymentStatus.idle);
      expect(state.errorMessage, isNull);
      expect(state.pendingGems, isNull);
      expect(state.pendingAmount, isNull);
      expect(state.selectedMethod, isNull);
      expect(state.preferenceId, isNull);
      expect(state.initPoint, isNull);
      expect(state.gemsBefore, isNull);
      expect(state.gemsAfter, isNull);
    });

    test('copyWith updates specified fields', () {
      const state = PaymentState();
      final updated = state.copyWith(
        status: PaymentStatus.completed,
        pendingGems: 100,
        pendingAmount: 5.0,
        selectedMethod: PaymentMethod.mercadopago,
        gemsBefore: 50,
        gemsAfter: 150,
      );
      expect(updated.status, PaymentStatus.completed);
      expect(updated.pendingGems, 100);
      expect(updated.pendingAmount, 5.0);
      expect(updated.selectedMethod, PaymentMethod.mercadopago);
      expect(updated.preferenceId, isNull);
      expect(updated.gemsBefore, 50);
      expect(updated.gemsAfter, 150);
    });

    test('copyWith clearError clears errorMessage', () {
      const state = PaymentState(errorMessage: 'some error');
      final updated = state.copyWith(clearError: true);
      expect(updated.errorMessage, isNull);
    });

    test('copyWith preserves unspecified fields', () {
      const state = PaymentState(pendingGems: 100, pendingAmount: 5.0);
      final updated = state.copyWith(status: PaymentStatus.waitingPayment);
      expect(updated.pendingGems, 100);
      expect(updated.pendingAmount, 5.0);
      expect(updated.status, PaymentStatus.waitingPayment);
      expect(updated.errorMessage, isNull);
    });
  });

  group('PaymentNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          learningProvider.overrideWith(MockLearningNotifier.new),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('build returns default state', () {
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.idle);
    });

    test('initiateWhatsApp sets waiting state with gems and price', () async {
      final notifier = container.read(paymentProvider.notifier);
      await notifier.initiateWhatsApp(gems: 80, price: 10.0);
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.waitingPayment);
      expect(state.pendingGems, 80);
      expect(state.pendingAmount, 10.0);
      expect(state.selectedMethod, PaymentMethod.whatsapp);
      expect(state.gemsBefore, 0);
      expect(state.errorMessage, isNull);
    });

    test('onPaymentSuccess sets completed status with gemsAfter', () async {
      final notifier = container.read(paymentProvider.notifier);
      await notifier.initiateWhatsApp(gems: 50, price: 5.0);
      notifier.onPaymentSuccess('user123|50|123456');
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.completed);
      expect(state.gemsAfter, 50);
    });

    test('onPaymentFailure sets failed status with default error', () async {
      final notifier = container.read(paymentProvider.notifier);
      await notifier.initiateWhatsApp(gems: 50, price: 5.0);
      notifier.onPaymentFailure();
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.failed);
      expect(state.errorMessage, 'El pago fue cancelado o no se completó');
    });

    test('onPaymentFailure sets failed status with custom error', () async {
      final notifier = container.read(paymentProvider.notifier);
      notifier.onPaymentFailure(error: 'Tarjeta rechazada');
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.failed);
      expect(state.errorMessage, 'Tarjeta rechazada');
    });

    test('reset clears everything back to default', () async {
      final notifier = container.read(paymentProvider.notifier);
      await notifier.initiateWhatsApp(gems: 80, price: 10.0);
      notifier.reset();
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.idle);
      expect(state.pendingGems, isNull);
      expect(state.pendingAmount, isNull);
      expect(state.selectedMethod, isNull);
    });

    test('onPaymentSuccess without initiate still completes', () {
      final notifier = container.read(paymentProvider.notifier);
      notifier.onPaymentSuccess('user123|50|123456');
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.completed);
    });

    test('refreshGems reads gemsAfter from learningProvider', () async {
      final notifier = container.read(paymentProvider.notifier);
      await notifier.initiateWhatsApp(gems: 50, price: 5.0);
      notifier.refreshGems();
      final state = container.read(paymentProvider);
      expect(state.gemsAfter, 0);
    });

    test('initiateWhatsApp clears previous error', () async {
      final notifier = container.read(paymentProvider.notifier);
      notifier.onPaymentFailure(error: 'previous error');
      await notifier.initiateWhatsApp(gems: 80, price: 10.0);
      final state = container.read(paymentProvider);
      expect(state.errorMessage, isNull);
      expect(state.pendingGems, 80);
    });
  });
}
