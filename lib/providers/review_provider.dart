import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'prefs_provider.dart';

class ReviewState {
  final Map<String, int> questionFailures;
  final Map<String, String> questionTopics;
  final Map<String, int> topicScores;
  final int totalReviews;

  const ReviewState({
    this.questionFailures = const {},
    this.questionTopics = const {},
    this.topicScores = const {},
    this.totalReviews = 0,
  });

  ReviewState copyWith({
    Map<String, int>? questionFailures,
    Map<String, String>? questionTopics,
    Map<String, int>? topicScores,
    int? totalReviews,
  }) {
    return ReviewState(
      questionFailures: questionFailures ?? this.questionFailures,
      questionTopics: questionTopics ?? this.questionTopics,
      topicScores: topicScores ?? this.topicScores,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}

class ReviewNotifier extends Notifier<ReviewState> {
  late final StorageService _storage;

  static const _keyQuestionFailures = 'review_q_fails';
  static const _keyQuestionTopics = 'review_q_topics';
  static const _keyTopicScores = 'review_t_scores';
  static const _keyTotalReviews = 'review_total';

  static const weakThreshold = 3;
  static const _maxScore = 10;

  @override
  ReviewState build() {
    _storage = StorageService(ref.watch(prefsProvider));
    _load();
    return state;
  }

  Map<String, int> get topicScores => Map.unmodifiable(state.topicScores);
  bool get hasWeakTopics => state.topicScores.values.any((s) => s > weakThreshold);
  bool get hasReviewableQuestions => state.questionFailures.isNotEmpty;
  List<String> get weakTopics => state.topicScores.entries
      .where((e) => e.value > weakThreshold)
      .map((e) => e.key)
      .toList();
  int get totalReviews => state.totalReviews;
  List<String> get failedQuestionIds => state.questionFailures.keys.toList();
  String? getTopicForQuestion(String questionId) => state.questionTopics[questionId];
  int failureCountFor(String questionId) => state.questionFailures[questionId] ?? 0;
  int scoreFor(String topic) => state.topicScores[topic] ?? 0;

  void recordMistake(String questionId, String topic) {
    final failures = Map<String, int>.from(state.questionFailures);
    final topics = Map<String, String>.from(state.questionTopics);
    final scores = Map<String, int>.from(state.topicScores);

    failures[questionId] = (failures[questionId] ?? 0) + 1;
    topics[questionId] = topic;
    scores[topic] = (scores[topic] ?? 0) + 1;
    if (scores[topic]! > _maxScore) scores[topic] = _maxScore;

    state = state.copyWith(
      questionFailures: failures,
      questionTopics: topics,
      topicScores: scores,
    );
    _save();
  }

  void recordCorrect(String questionId) {
    final topic = state.questionTopics[questionId];
    final failures = Map<String, int>.from(state.questionFailures);
    final topics = Map<String, String>.from(state.questionTopics);
    final scores = Map<String, int>.from(state.topicScores);

    if (failures.containsKey(questionId)) {
      final count = failures[questionId]! - 1;
      if (count <= 0) {
        failures.remove(questionId);
        topics.remove(questionId);
      } else {
        failures[questionId] = count;
      }
    }

    if (topic != null && scores.containsKey(topic)) {
      final score = scores[topic]! - 1;
      if (score <= 0) {
        scores.remove(topic);
      } else {
        scores[topic] = score;
      }
    }

    state = state.copyWith(
      questionFailures: failures,
      questionTopics: topics,
      topicScores: scores,
    );
    _save();
  }

  void markReviewCompleted() {
    state = state.copyWith(totalReviews: state.totalReviews + 1);
    _save();
  }

  void reload() {
    _load();
  }

  void _save() {
    final s = state;
    _storage.setJson(
      _keyQuestionFailures,
      s.questionFailures.map((k, v) => MapEntry<String, dynamic>(k, v)),
    );
    _storage.setJson(_keyQuestionTopics, s.questionTopics);
    _storage.setJson(
      _keyTopicScores,
      s.topicScores.map((k, v) => MapEntry<String, dynamic>(k, v)),
    );
    _storage.setInt(_keyTotalReviews, s.totalReviews);
  }

  void _load() {
    try {
      final qf = _storage.getJson(_keyQuestionFailures);
      final qfMap = qf != null
          ? qf.map((k, v) => MapEntry(k, (v as num).toInt()))
          : <String, int>{};

      final qt = _storage.getJson(_keyQuestionTopics);
      final qtMap = qt?.cast<String, String>() ?? <String, String>{};

      final ts = _storage.getJson(_keyTopicScores);
      final tsMap = ts != null
          ? ts.map((k, v) => MapEntry(k, (v as num).toInt()))
          : <String, int>{};

      final total = _storage.getInt(_keyTotalReviews);

      state = ReviewState(
        questionFailures: qfMap,
        questionTopics: qtMap,
        topicScores: tsMap,
        totalReviews: total,
      );
    } catch (_) {
      state = const ReviewState();
    }
  }
}
