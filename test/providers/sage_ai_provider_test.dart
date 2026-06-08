import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/sage_ai_provider.dart';
import 'package:sagen/providers/providers.dart';
import '../helpers/mock_learning_provider.dart';

void main() {
  group('SageAiProvider', () {
    late ProviderContainer container;
    late MockLearningNotifier mockLearning;

    setUp(() {
      mockLearning = MockLearningNotifier();
      container = ProviderContainer(
        overrides: [
          learningProvider.overrideWith(() => mockLearning),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is idle with no loading or streaming', () {
      final state = container.read(sageAiProvider);
      expect(state.status, SageAiChatStatus.idle);
      expect(state.isLoading, false);
      expect(state.isStreaming, false);
      expect(state.isBusy, false);
    });

    test('isLocked returns true when lessonsCompleted < 10', () {
      container.read(learningProvider);
      mockLearning.lessonsCompleted = 5;
      final state = container.read(sageAiProvider);
      expect(state.isLocked, true);
    });

    test('isLocked returns false when lessonsCompleted >= 10', () {
      container.read(learningProvider);
      mockLearning.lessonsCompleted = 10;
      final state = container.read(sageAiProvider);
      expect(state.isLocked, false);
    });

    test('clearMessages resets state correctly', () {
      final notifier = container.read(sageAiProvider.notifier);
      notifier.clearMessages();
      final state = container.read(sageAiProvider);
      expect(state.messages, isEmpty);
      expect(state.status, SageAiChatStatus.idle);
      expect(state.errorMessage, isNull);
      expect(state.streamingText, '');
    });

    test('suggestionChips returns expected list', () {
      final state = container.read(sageAiProvider);
      expect(state.suggestionChips, [
        '¿Qué es el phishing?',
        'Crea una contraseña segura',
        'Identifica una estafa',
      ]);
    });
  });
}
