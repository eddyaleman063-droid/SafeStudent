import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';

void main() {
  group('SessionNotifier', () {
    test('initial state is intro with 3 lives and no challenge', () {
      final container = ProviderContainer(overrides: [
        sessionProvider.overrideWith(() => SessionNotifier()),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(sessionProvider.notifier);

      expect(notifier.state.phase, SessionPhase.intro);
      expect(notifier.currentChallenge, isNull);
      expect(notifier.lives, 3);
      expect(notifier.correctCount, 0);
      expect(notifier.wrongCount, 0);
    });

    test('startSession initializes playing state with challenges', () {
      final container = ProviderContainer(overrides: [
        sessionProvider.overrideWith(() => SessionNotifier()),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(sessionProvider.notifier);

      notifier.startSession('stage_1', 'non_existent', count: 5);

      expect(notifier.state.phase, SessionPhase.playing);
      expect(notifier.currentChallenge, isNotNull);
      expect(notifier.challenges.length, 5);
      expect(notifier.lives, 3);
      expect(notifier.totalQuestions, 5);
      expect(notifier.currentIndex, 0);
    });

    test('submitAnswer handles correct and incorrect feedback', () {
      final container = ProviderContainer(overrides: [
        sessionProvider.overrideWith(() => SessionNotifier()),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(sessionProvider.notifier);

      notifier.startSession('stage_1', 'non_existent', count: 5);

      final correctIdx = notifier.currentChallenge!.correctIndex;
      notifier.submitAnswer(correctIdx);
      expect(notifier.state.phase, SessionPhase.feedback);
      expect(notifier.feedbackCorrect, true);
      expect(notifier.correctCount, 1);
      expect(notifier.lives, 3);

      notifier.nextQuestion();
      final wrongIdx =
          (notifier.currentChallenge!.correctIndex + 1) %
          notifier.currentChallenge!.options.length;
      notifier.submitAnswer(wrongIdx);
      expect(notifier.state.phase, SessionPhase.feedback);
      expect(notifier.feedbackCorrect, false);
      expect(notifier.wrongCount, 1);
      expect(notifier.lives, 2);
    });

    test('gameOver when lives reach 0', () async {
      final container = ProviderContainer(overrides: [
        sessionProvider.overrideWith(() => SessionNotifier()),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(sessionProvider.notifier);

      notifier.startSession('stage_1', 'non_existent', count: 5);

      for (int i = 0; i < 3; i++) {
        final wrongIdx =
            (notifier.currentChallenge!.correctIndex + 1) %
            notifier.currentChallenge!.options.length;
        notifier.submitAnswer(wrongIdx);
        if (i < 2) notifier.nextQuestion();
      }

      expect(notifier.lives, 0);
      await Future.microtask(() {});
      expect(notifier.state.phase, SessionPhase.gameOver);
    });

    test('completed state when all questions answered', () {
      final container = ProviderContainer(overrides: [
        sessionProvider.overrideWith(() => SessionNotifier()),
      ]);
      addTearDown(() => container.dispose());
      final notifier = container.read(sessionProvider.notifier);

      notifier.startSession('stage_1', 'non_existent', count: 3);

      for (int i = 0; i < 3; i++) {
        notifier.submitAnswer(notifier.currentChallenge!.correctIndex);
        notifier.nextQuestion();
      }

      expect(notifier.state.phase, SessionPhase.completed);
      expect(notifier.correctCount, 3);
      expect(notifier.wrongCount, 0);
    });
  });
}
