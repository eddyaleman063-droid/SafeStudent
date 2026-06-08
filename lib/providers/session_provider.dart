import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learning/challenge.dart';
import '../services/question_bank.dart';

enum SessionPhase { intro, playing, feedback, gameOver, completed }

class SessionState {
  final Challenge? currentChallenge;
  final List<Challenge> challenges;
  final int currentIndex;
  final int lives;
  final int correctCount;
  final int wrongCount;
  final int totalQuestions;
  final int feedbackSelected;
  final bool feedbackCorrect;
  final SessionPhase phase;

  const SessionState({
    this.currentChallenge,
    this.challenges = const [],
    this.currentIndex = 0,
    this.lives = 3,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.totalQuestions = 0,
    this.feedbackSelected = -1,
    this.feedbackCorrect = false,
    this.phase = SessionPhase.intro,
  });

  SessionState copyWith({
    Challenge? Function()? currentChallenge,
    List<Challenge> Function()? challenges,
    int? currentIndex,
    int? lives,
    int? correctCount,
    int? wrongCount,
    int? totalQuestions,
    int? feedbackSelected,
    bool? feedbackCorrect,
    SessionPhase? phase,
  }) {
    return SessionState(
      currentChallenge: currentChallenge != null ? currentChallenge() : this.currentChallenge,
      challenges: challenges != null ? challenges() : this.challenges,
      currentIndex: currentIndex ?? this.currentIndex,
      lives: lives ?? this.lives,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      feedbackSelected: feedbackSelected ?? this.feedbackSelected,
      feedbackCorrect: feedbackCorrect ?? this.feedbackCorrect,
      phase: phase ?? this.phase,
    );
  }

  double get progress => totalQuestions > 0 ? currentIndex / totalQuestions : 0;
  int get segmentCount => totalQuestions;
  int get completedSegments => currentIndex;
  double get accuracy => correctCount + wrongCount > 0
      ? correctCount / (correctCount + wrongCount)
      : 0;
  bool get isPerfect => wrongCount == 0 && correctCount == totalQuestions;
  int get earnedXp {
    final base = correctCount * 15;
    final bonus = isPerfect ? 30 : 0;
    return base + bonus;
  }
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  Challenge? get currentChallenge => state.currentChallenge;
  List<Challenge> get challenges => List.unmodifiable(state.challenges);
  int get currentIndex => state.currentIndex;
  int get lives => state.lives;
  int get correctCount => state.correctCount;
  int get wrongCount => state.wrongCount;
  int get totalQuestions => state.totalQuestions;
  int get feedbackSelected => state.feedbackSelected;
  bool get feedbackCorrect => state.feedbackCorrect;
  SessionPhase get phase => state.phase;
  double get progress => state.progress;
  int get segmentCount => state.segmentCount;
  int get completedSegments => state.completedSegments;
  double get accuracy => state.accuracy;
  bool get isPerfect => state.isPerfect;
  int get earnedXp => state.earnedXp;

  void startSession(String stageId, String lessonId, {int count = 5}) {
    var challenges = QuestionBank.instance.getQuestionsForLesson(stageId, lessonId, count: count);
    if (challenges.isEmpty) {
      challenges = QuestionBank.instance.getQuestionsForLesson(stageId, lessonId, count: 3);
    }
    final totalQuestions = challenges.length;
    state = state.copyWith(
      challenges: () => challenges,
      totalQuestions: totalQuestions,
      currentIndex: 0,
      lives: 3,
      correctCount: 0,
      wrongCount: 0,
      feedbackSelected: -1,
      feedbackCorrect: false,
      phase: SessionPhase.playing,
      currentChallenge: () => challenges.isNotEmpty ? challenges[0] : null,
    );
  }

  void submitAnswer(int selectedIndex) {
    if (state.phase != SessionPhase.playing || state.currentChallenge == null) return;
    final feedbackCorrect = selectedIndex == state.currentChallenge!.correctIndex;
    state = state.copyWith(
      feedbackSelected: selectedIndex,
      feedbackCorrect: feedbackCorrect,
      correctCount: feedbackCorrect ? state.correctCount + 1 : state.correctCount,
      wrongCount: feedbackCorrect ? state.wrongCount : state.wrongCount + 1,
      lives: feedbackCorrect ? state.lives : state.lives - 1,
      phase: SessionPhase.feedback,
    );

    if (state.lives <= 0) {
      Future.microtask(() {
        state = state.copyWith(phase: SessionPhase.gameOver);
      });
    }
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.totalQuestions) {
      state = state.copyWith(phase: SessionPhase.completed);
      return;
    }
    final nextIndex = state.currentIndex + 1;
    state = state.copyWith(
      currentIndex: nextIndex,
      currentChallenge: () => state.challenges[nextIndex],
      feedbackSelected: -1,
      feedbackCorrect: false,
      phase: SessionPhase.playing,
    );
  }

  void resetSession() {
    state = const SessionState();
  }

  void retry() {
    startSession('', '', count: state.totalQuestions);
  }
}
