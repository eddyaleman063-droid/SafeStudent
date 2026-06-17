import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/models/learning/lesson_type.dart';
import 'package:sagen/services/question_bank.dart';

void main() {
  late QuestionBank qb;

  setUp(() {
    qb = QuestionBank.instance;
    final jsonStr = File('assets/questions.json').readAsStringSync();
    qb.loadFromString(jsonStr);
  });

  group('QuestionBank', () {
    test('singleton returns same instance', () {
      expect(QuestionBank.instance, same(qb));
    });

    group('getQuestionsForLesson', () {
      test('returns count questions from stage pool', () {
        final result = qb.getQuestionsForLesson('ac_st1', 'any_lesson', count: 10);
        expect(result.length, 10);
        for (final c in result) {
          expect(c.id, startsWith('acs1_'));
        }
      });

      test('filters by difficulty', () {
        final result = qb.getQuestionsForLesson('ac_st1', 'any_lesson', count: 10);
        for (final c in result) {
          expect(c.difficulty, inInclusiveRange(0, 1));
        }
      });

      test('difficulty filter applies to initial selection (supplement may add others)', () {
        final result = qb.getQuestionsForLesson('ac_st1', 'any_lesson', count: 10);
        final diff0or1 = result.where((c) => c.difficulty >= 0 && c.difficulty <= 1).length;
        expect(diff0or1, greaterThan(0));
      });

      test('falls back to topic pool when stage not found', () {
        final result = qb.getQuestionsForLesson('unknown_stage', 's1_l1', count: 10);
        expect(result.length, 10);
        final fromTopic = result.where((c) => c.id.startsWith('tp_s1_l1'));
        expect(fromTopic.length, 5);
      });

      test('falls back to default pool when nothing matches', () {
        final result = qb.getQuestionsForLesson('unknown_stage', 'unknown_lesson', count: 10);
        expect(result.length, 10);
      });

      test('supplements from full pool when filtered pool is short', () {
        final result = qb.getQuestionsForLesson('ac_st1', 'any_lesson', count: 60);
        expect(result.length, 60);
      });

      test('supplements from topic default when topic pool is short', () {
        final result = qb.getQuestionsForLesson('unknown_stage', 's1_l1', count: 25);
        expect(result.length, greaterThan(2));
      });
    });

    group('randomForType', () {
      test('returns a challenge of the requested type', () {
        final result = qb.randomForType(LessonType.trueFalse);
        expect(result.type, LessonType.trueFalse);
      });

      test('returns multipleChoice for createPassword type', () {
        final result = qb.randomForType(LessonType.createPassword);
        expect(result.type, LessonType.createPassword);
      });

      test('returns different results across calls (random)', () {
        final results = <String>{};
        for (int i = 0; i < 50; i++) {
          results.add(qb.randomForType(LessonType.multipleChoice).id);
        }
        expect(results.length, greaterThan(1));
      });
    });

    group('getById', () {
      test('returns null for unknown id', () {
        expect(qb.getById('no_such_id'), isNull);
      });

      test('finds challenge from _questionsByType', () {
        final result = qb.getById('qtype_trueFalse_01');
        expect(result, isNotNull);
        expect(result!.id, 'qtype_trueFalse_01');
        expect(result.type, LessonType.trueFalse);
      });

      test('finds challenge from _topicPools', () {
        final result = qb.getById('tp_s1_l1_01');
        expect(result, isNotNull);
        expect(result!.id, 'tp_s1_l1_01');
      });

      test('finds challenge from _stagePools', () {
        final result = qb.getById('acs1_001');
        expect(result, isNotNull);
        expect(result!.id, 'acs1_001');
      });

      test('finds createPassword question', () {
        final result = qb.getById('qtype_createPassword_01');
        expect(result, isNotNull);
        expect(result!.type, LessonType.createPassword);
      });
    });
  });
}
