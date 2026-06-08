import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/models/learning/quiz_score.dart';

void main() {
  group('QuizScoreCalculator', () {
    test('xp = correct * 15 when no time budget', () {
      const score = QuizScoreCalculator(
        correctCount: 8,
        totalQuestions: 10,
        timeSpentSeconds: 100,
        timeBudgetSeconds: 0,
      );
      expect(score.xp, 120);
    });

    test('xp includes time bonus when time budget set', () {
      const score = QuizScoreCalculator(
        correctCount: 8,
        totalQuestions: 10,
        timeSpentSeconds: 50,
        timeBudgetSeconds: 100,
      );
      final timeBonus = ((50 / 100) * 20).round();
      expect(score.xp, 8 * 15 + timeBonus);
    });

    test('xp gives full time bonus when no time spent', () {
      const score = QuizScoreCalculator(
        correctCount: 5,
        totalQuestions: 5,
        timeSpentSeconds: 0,
        timeBudgetSeconds: 60,
      );
      expect(score.xp, 5 * 15 + 20);
    });

    test('xp gives zero time bonus when all time used', () {
      const score = QuizScoreCalculator(
        correctCount: 5,
        totalQuestions: 5,
        timeSpentSeconds: 60,
        timeBudgetSeconds: 60,
      );
      expect(score.xp, 5 * 15);
    });

    test('xp handles time spent exceeding budget', () {
      const score = QuizScoreCalculator(
        correctCount: 3,
        totalQuestions: 5,
        timeSpentSeconds: 120,
        timeBudgetSeconds: 60,
      );
      expect(score.xp, 3 * 15);
    });

    test('accuracyPercent returns 0 for zero total', () {
      const score = QuizScoreCalculator(
        correctCount: 0,
        totalQuestions: 0,
        timeSpentSeconds: 0,
      );
      expect(score.accuracyPercent, 0);
    });

    test('accuracyPercent returns 100 for all correct', () {
      const score = QuizScoreCalculator(
        correctCount: 10,
        totalQuestions: 10,
        timeSpentSeconds: 60,
      );
      expect(score.accuracyPercent, 100);
    });

    test('accuracyPercent returns correct percentage', () {
      const score = QuizScoreCalculator(
        correctCount: 7,
        totalQuestions: 10,
        timeSpentSeconds: 60,
      );
      expect(score.accuracyPercent, 70);
    });

    test('avgTimePerQuestion returns 0 for zero total', () {
      const score = QuizScoreCalculator(
        correctCount: 0,
        totalQuestions: 0,
        timeSpentSeconds: 0,
      );
      expect(score.avgTimePerQuestion, 0);
    });

    test('avgTimePerQuestion calculates correctly', () {
      const score = QuizScoreCalculator(
        correctCount: 8,
        totalQuestions: 10,
        timeSpentSeconds: 50,
      );
      expect(score.avgTimePerQuestion, 5);
    });
  });
}
