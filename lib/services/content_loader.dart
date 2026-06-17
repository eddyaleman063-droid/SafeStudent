import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/learning/challenge.dart';
import '../models/learning/lesson_type.dart';
import '../models/learning/stage.dart';

class ContentLoader {
  static final ContentLoader instance = ContentLoader._();
  ContentLoader._();

  bool _loaded = false;
  List<Stage> _stages = [];
  Map<LessonType, List<Challenge>> _questionsByType = {};
  final Map<String, List<Challenge>> _topicPools = {};
  final Map<String, List<Challenge>> _stageQuestions = {};
  final Map<String, List<Challenge>> _lessonQuestions = {};

  Future<void> load() async {
    if (_loaded) return;
    await _loadStages();
    await _loadQuestionsByType();
    await _loadTopicPools();
    await _loadAllStageQuestions();
    _loaded = true;
  }

  Future<void> _loadStages() async {
    final jsonStr = await rootBundle.loadString('assets/content/stages.json');
    final list = jsonDecode(jsonStr) as List;
    _stages = list.map((j) => Stage.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> _loadQuestionsByType() async {
    final jsonStr = await rootBundle.loadString('assets/content/questions_by_type.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    _questionsByType = {};
    for (final entry in data.entries) {
      final type = _parseType(entry.key);
      final list = (entry.value as List).map((e) => Challenge.fromJson(e as Map<String, dynamic>)).toList();
      _questionsByType[type] = list;
    }
  }

  Future<void> _loadTopicPools() async {
    final jsonStr = await rootBundle.loadString('assets/content/questions_default.json');
    final list = jsonDecode(jsonStr) as List;
    _topicPools['default'] = list.map((e) => Challenge.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _loadAllStageQuestions() async {
    for (final stage in _stages) {
      final jsonStr = await rootBundle.loadString('assets/content/questions_${stage.id}.json');
      final list = jsonDecode(jsonStr) as List;
      final questions = list.map((e) => Challenge.fromJson(e as Map<String, dynamic>)).toList();
      _stageQuestions[stage.id] = questions;
    }
  }

  LessonType _parseType(String type) {
    return LessonType.values.firstWhere(
      (t) => t.name == type,
      orElse: () => LessonType.multipleChoice,
    );
  }

  bool get isLoaded => _loaded;
  List<Stage> get stages => List.unmodifiable(_stages);
  Map<LessonType, List<Challenge>> get questionsByType => _questionsByType;
  Map<String, List<Challenge>> get topicPools => _topicPools;
  Map<String, List<Challenge>> get stageQuestions => _stageQuestions;
  Map<String, List<Challenge>> get lessonQuestions => _lessonQuestions;
}
