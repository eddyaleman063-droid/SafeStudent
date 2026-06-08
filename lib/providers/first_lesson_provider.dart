import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learning/challenge.dart';
import '../services/question_bank.dart';
import 'onboarding_wizard_provider.dart';

class FirstLessonState {
  final List<Challenge> questions;
  final int currentIndex;
  final int correctCount;
  final int wrongCount;
  final DateTime? startTime;
  final bool showFeedback;
  final int? selectedAnswer;
  final bool answeredCorrectly;

  const FirstLessonState({
    this.questions = const [],
    this.currentIndex = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.startTime,
    this.showFeedback = false,
    this.selectedAnswer,
    this.answeredCorrectly = false,
  });

  int get totalQuestions => questions.length;
  bool get isComplete => currentIndex >= totalQuestions && totalQuestions > 0;
  bool get isPerfect => correctCount == totalQuestions && correctCount > 0;
  double get accuracy => (correctCount + wrongCount) > 0 ? correctCount / (correctCount + wrongCount) : 0;
  int get earnedXp => (correctCount * 15) + (isPerfect ? 30 : 0);
  Duration? get elapsedTime => startTime != null ? DateTime.now().difference(startTime!) : null;
  Challenge? get currentChallenge => currentIndex < questions.length ? questions[currentIndex] : null;
}

class FirstLessonNotifier extends Notifier<FirstLessonState> {
  final _random = Random();

  @override
  FirstLessonState build() => const FirstLessonState();

  void startLesson() {
    final wizardState = ref.read(onboardingWizardProvider);
    final levelData = wizardState.sectionData[2];
    final level = int.tryParse(levelData?.toString() ?? '') ?? 3;

    List<Challenge> allQuestions;
    if (level <= 2) {
      allQuestions = [
        ...QuestionBank.instance.getQuestionsForLesson('', 'default', count: 15),
      ];
    } else if (level <= 3) {
      allQuestions = [
        ...QuestionBank.instance.getQuestionsForLesson('', 'default', count: 10),
        ...QuestionBank.instance.getQuestionsForLesson('', 's3_l1', count: 3),
        ...QuestionBank.instance.getQuestionsForLesson('', 's4_l1', count: 2),
      ];
    } else {
      allQuestions = [
        ...QuestionBank.instance.getQuestionsForLesson('', 's4_l1', count: 5),
        ...QuestionBank.instance.getQuestionsForLesson('', 's6_l1', count: 5),
        ...QuestionBank.instance.getQuestionsForLesson('', 's7_l1', count: 5),
      ];
    }

    final shuffled = List<Challenge>.from(allQuestions)..shuffle(_random);
    final selected = shuffled.take(15).toList();

    state = FirstLessonState(
      questions: selected,
      startTime: DateTime.now(),
    );
  }

  void submitAnswer(int selectedIndex) {
    final question = state.currentChallenge;
    if (question == null || state.showFeedback) return;

    final correct = selectedIndex == question.correctIndex;
    state = FirstLessonState(
      questions: state.questions,
      currentIndex: state.currentIndex,
      correctCount: correct ? state.correctCount + 1 : state.correctCount,
      wrongCount: correct ? state.wrongCount : state.wrongCount + 1,
      startTime: state.startTime,
      showFeedback: true,
      selectedAnswer: selectedIndex,
      answeredCorrectly: correct,
    );
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.totalQuestions) {
      state = FirstLessonState(
        questions: state.questions,
        currentIndex: state.currentIndex + 1,
        correctCount: state.correctCount,
        wrongCount: state.wrongCount,
        startTime: state.startTime,
        showFeedback: false,
      );
      return;
    }
    state = FirstLessonState(
      questions: state.questions,
      currentIndex: state.currentIndex + 1,
      correctCount: state.correctCount,
      wrongCount: state.wrongCount,
      startTime: state.startTime,
      showFeedback: false,
    );
  }

  void reset() {
    state = const FirstLessonState();
  }
}

final firstLessonProvider = NotifierProvider<FirstLessonNotifier, FirstLessonState>(
  FirstLessonNotifier.new,
);
