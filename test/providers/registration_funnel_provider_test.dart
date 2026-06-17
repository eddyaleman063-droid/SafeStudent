import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/providers/providers.dart';

void main() {
  group('RegistrationFunnelState', () {
    test('initial state has correct defaults', () {
      const state = RegistrationFunnelState();
      expect(state.currentStep, 0);
      expect(state.isGuest, false);
      expect(state.age, 0);
      expect(state.authMethod, '');
      expect(state.email, '');
      expect(state.name, '');
      expect(state.surname, '');
    });

    test('copyWith updates only specified fields', () {
      const state = RegistrationFunnelState();
      final updated = state.copyWith(age: 25, name: 'Juan', authMethod: 'google');
      expect(updated.age, 25);
      expect(updated.name, 'Juan');
      expect(updated.authMethod, 'google');
      expect(updated.email, '');
      expect(updated.currentStep, 0);
    });
  });

  group('RegistrationFunnelNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('build returns default state', () {
      final state = container.read(registrationFunnelProvider);
      expect(state.currentStep, 0);
    });

    test('nextStep increments currentStep', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.nextStep();
      expect(container.read(registrationFunnelProvider).currentStep, 1);
      notifier.nextStep();
      expect(container.read(registrationFunnelProvider).currentStep, 2);
    });

    test('goToStep jumps to specified step', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.goToStep(5);
      expect(container.read(registrationFunnelProvider).currentStep, 5);
    });

    test('skipToHome sets isGuest to true', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.skipToHome();
      expect(container.read(registrationFunnelProvider).isGuest, true);
    });

    test('setAge updates age', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.setAge(25);
      expect(container.read(registrationFunnelProvider).age, 25);
    });

    test('setAuthMethod updates auth method', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.setAuthMethod('google');
      expect(container.read(registrationFunnelProvider).authMethod, 'google');
    });

    test('setEmail and setPassword update credentials', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.setEmail('test@example.com');
      notifier.setPassword('secret123');
      expect(container.read(registrationFunnelProvider).email, 'test@example.com');
      expect(container.read(registrationFunnelProvider).password, 'secret123');
    });

    test('setName and setSurname update name fields', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.setName('Juan');
      notifier.setSurname('Pérez');
      expect(container.read(registrationFunnelProvider).name, 'Juan');
      expect(container.read(registrationFunnelProvider).surname, 'Pérez');
    });

    test('setStartingPoint updates starting point', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.setStartingPoint('beginner');
      expect(container.read(registrationFunnelProvider).startingPoint, 'beginner');
    });

    test('reset returns to initial state', () {
      final notifier = container.read(registrationFunnelProvider.notifier);
      notifier.setAge(25);
      notifier.setAuthMethod('email');
      notifier.setEmail('test@example.com');
      notifier.nextStep();
      notifier.reset();
      final state = container.read(registrationFunnelProvider);
      expect(state.currentStep, 0);
      expect(state.age, 0);
      expect(state.authMethod, '');
    });
  });

  group('Funnel validation providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('funnelAgeValidProvider is false for age 0', () {
      expect(container.read(funnelAgeValidProvider), isFalse);
    });

    test('funnelAgeValidProvider is true for age >= 2', () {
      container.read(registrationFunnelProvider.notifier).setAge(14);
      expect(container.read(funnelAgeValidProvider), isTrue);
    });

    test('funnelEmailValidProvider validates email format', () {
      expect(container.read(funnelEmailValidProvider), isFalse);
      container.read(registrationFunnelProvider.notifier).setEmail('test');
      expect(container.read(funnelEmailValidProvider), isFalse);
      container.read(registrationFunnelProvider.notifier).setEmail('test@example.com');
      expect(container.read(funnelEmailValidProvider), isTrue);
    });

    test('funnelPasswordValidProvider checks minimum length', () {
      expect(container.read(funnelPasswordValidProvider), isFalse);
      container.read(registrationFunnelProvider.notifier).setPassword('abc');
      expect(container.read(funnelPasswordValidProvider), isFalse);
      container.read(registrationFunnelProvider.notifier).setPassword('abcdef');
      expect(container.read(funnelPasswordValidProvider), isTrue);
    });

    test('funnelNameValidProvider requires both name and surname', () {
      expect(container.read(funnelNameValidProvider), isFalse);
      container.read(registrationFunnelProvider.notifier).setName('Juan');
      expect(container.read(funnelNameValidProvider), isFalse);
      container.read(registrationFunnelProvider.notifier).setSurname('Pérez');
      expect(container.read(funnelNameValidProvider), isTrue);
    });

    test('funnelCanContinueProvider returns true for step 0', () {
      expect(container.read(funnelCanContinueProvider), isTrue);
    });

    test('funnelCanContinueProvider returns false for step 1 with age 0', () {
      container.read(registrationFunnelProvider.notifier).goToStep(1);
      expect(container.read(funnelCanContinueProvider), isFalse);
    });

    test('funnelCanContinueProvider returns true for step 1 with valid age', () {
      container.read(registrationFunnelProvider.notifier).goToStep(1);
      container.read(registrationFunnelProvider.notifier).setAge(14);
      expect(container.read(funnelCanContinueProvider), isTrue);
    });

    test('funnelCanContinueProvider returns false for step 2 without auth method', () {
      container.read(registrationFunnelProvider.notifier).goToStep(2);
      expect(container.read(funnelCanContinueProvider), isFalse);
    });

    test('funnelCanContinueProvider returns true for step 2 with auth method', () {
      container.read(registrationFunnelProvider.notifier).goToStep(2);
      container.read(registrationFunnelProvider.notifier).setAuthMethod('google');
      expect(container.read(funnelCanContinueProvider), isTrue);
    });
  });
}
