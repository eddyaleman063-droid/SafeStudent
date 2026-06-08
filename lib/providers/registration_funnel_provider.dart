import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationFunnelState {
  final int currentStep;
  final bool isGuest;
  final int age;
  final String authMethod;
  final String email;
  final String password;
  final String name;
  final String surname;

  const RegistrationFunnelState({
    this.currentStep = 0,
    this.isGuest = false,
    this.age = 0,
    this.authMethod = '',
    this.email = '',
    this.password = '',
    this.name = '',
    this.surname = '',
  });

  RegistrationFunnelState copyWith({
    int? currentStep,
    bool? isGuest,
    int? age,
    String? authMethod,
    String? email,
    String? password,
    String? name,
    String? surname,
  }) {
    return RegistrationFunnelState(
      currentStep: currentStep ?? this.currentStep,
      isGuest: isGuest ?? this.isGuest,
      age: age ?? this.age,
      authMethod: authMethod ?? this.authMethod,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      surname: surname ?? this.surname,
    );
  }

  void validateAge(int value) {}
}

enum FunnelStep {
  hook,
  age,
  authMethod,
  email,
  password,
  name,
  success,
}

class RegistrationFunnelNotifier extends Notifier<RegistrationFunnelState> {
  @override
  RegistrationFunnelState build() => const RegistrationFunnelState();

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void skipToHome() {
    state = state.copyWith(isGuest: true);
  }

  void setAge(int value) {
    state = state.copyWith(age: value);
  }

  void setAuthMethod(String method) {
    state = state.copyWith(authMethod: method);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setSurname(String value) {
    state = state.copyWith(surname: value);
  }

  void reset() {
    state = const RegistrationFunnelState();
  }
}

final registrationFunnelProvider = NotifierProvider<RegistrationFunnelNotifier, RegistrationFunnelState>(
  RegistrationFunnelNotifier.new,
);

final funnelAgeValidProvider = Provider<bool>((ref) {
  final state = ref.watch(registrationFunnelProvider);
  return state.age >= 2;
});

final funnelEmailValidProvider = Provider<bool>((ref) {
  final state = ref.watch(registrationFunnelProvider);
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(state.email);
});

final funnelPasswordValidProvider = Provider<bool>((ref) {
  final state = ref.watch(registrationFunnelProvider);
  return state.password.length >= 6;
});

final funnelNameValidProvider = Provider<bool>((ref) {
  final state = ref.watch(registrationFunnelProvider);
  return state.name.trim().isNotEmpty && state.surname.trim().isNotEmpty;
});

final funnelCanContinueProvider = Provider<bool>((ref) {
  final state = ref.watch(registrationFunnelProvider);
  switch (state.currentStep) {
    case 0: return true;
    case 1: return ref.watch(funnelAgeValidProvider);
    case 2: return state.authMethod.isNotEmpty;
    case 3: return state.authMethod == 'google' || ref.watch(funnelEmailValidProvider);
    case 4: return ref.watch(funnelPasswordValidProvider);
    case 5: return ref.watch(funnelNameValidProvider);
    default: return true;
  }
});
