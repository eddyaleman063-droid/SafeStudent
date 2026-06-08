import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lesson.dart';

part 'stage.freezed.dart';
part 'stage.g.dart';

class _ColorConverter implements JsonConverter<Color, int> {
  const _ColorConverter();
  @override
  Color fromJson(int json) => Color(json);
  @override
  int toJson(Color object) => object.toARGB32();
}

class _IconConverter implements JsonConverter<IconData, String> {
  const _IconConverter();
  @override
  IconData fromJson(String json) => Icons.shield_rounded;
  @override
  String toJson(IconData object) => 'shield_rounded';
}

@unfreezed
class Stage with _$Stage {
  Stage._();

  factory Stage({
    required String id,
    required String title,
    required String subtitle,
    @_ColorConverter() required Color accent,
    @_IconConverter() required IconData icon,
    required List<Lesson> lessons,
    @Default(false) bool unlocked,
  }) = _Stage;

  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);

  double get progress {
    if (lessons.isEmpty) return 0;
    final done = lessons.where((l) => l.completed).length;
    return done / lessons.length;
  }

  int get completedCount => lessons.where((l) => l.completed).length;

  bool get isComplete => lessons.every((l) => l.completed);

  Lesson? get nextLesson => lessons.where((l) => !l.completed).firstOrNull;
}
