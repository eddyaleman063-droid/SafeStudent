import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lesson_type.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

@freezed
class Challenge with _$Challenge {
  const Challenge._();

  const factory Challenge({
    required String id,
    required String question,
    required LessonType type,
    required List<String> options,
    required int correctIndex,
    required String explanation,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) => _$ChallengeFromJson(json);

  Color get color {
    switch (type) {
      case LessonType.trueFalse:
        return const Color(0xFF1565C0);
      case LessonType.multipleChoice:
        return const Color(0xFF7C3AED);
      case LessonType.completePhrase:
        return const Color(0xFF00897B);
      case LessonType.detectRisk:
        return const Color(0xFFE65100);
      case LessonType.createPassword:
        return const Color(0xFF2E7D32);
      case LessonType.whatWouldYouDo:
        return const Color(0xFF6A1B9A);
      case LessonType.miniCase:
        return const Color(0xFFFFB300);
    }
  }
}
