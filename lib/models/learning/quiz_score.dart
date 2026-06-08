class QuizScoreCalculator {
  final int correctCount;
  final int totalQuestions;
  final int timeSpentSeconds;
  final int timeBudgetSeconds;

  const QuizScoreCalculator({
    required this.correctCount,
    required this.totalQuestions,
    required this.timeSpentSeconds,
    this.timeBudgetSeconds = 0,
  });

  int get xp {
    final base = correctCount * 15;
    final remaining = (timeBudgetSeconds - timeSpentSeconds).clamp(0, timeBudgetSeconds);
    final timeBonus = timeBudgetSeconds > 0
        ? ((remaining / timeBudgetSeconds) * 20).round()
        : 0;
    return base + timeBonus;
  }

  double get accuracyPercent {
    if (totalQuestions <= 0) return 0;
    return (correctCount / totalQuestions) * 100;
  }

  double get avgTimePerQuestion {
    if (totalQuestions <= 0 || timeSpentSeconds <= 0) return 0;
    return timeSpentSeconds / totalQuestions;
  }
}
