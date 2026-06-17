import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learning/stage.dart';
import '../services/app_logger.dart';
import '../services/cloud_sync_service.dart';
import '../services/learning_stage_service.dart';

const _checksumSalt = 'sagen_v5_integrity';

abstract class LearningRepository {
  List<Stage> get stages;
  int get gems;
  int get xp;
  int get currentLevel;
  int get lessonsCompleted;
  List<String> get achievements;
  int get totalXpEarned;
  int get totalGemsEarned;

  Future<void> load();
  Future<List<Stage>> fetchStages();
  void saveStages(List<Stage> stages);
  void saveGems(int amount);
  void saveXp(int amount);
  void saveLevel(int level);
  void saveLessonsCompleted(int count);
  void saveAchievements(List<String> achievements);
  void saveTotalXp(int amount);
  void saveTotalGems(int amount);
  void saveIntegrity();
  bool spendGems(int amount);
  void addGems(int amount, {bool trackTotal = true});
  void addXp(int amount, {bool trackTotal = true});
}

class LearningRepositoryImpl implements LearningRepository {
  final SharedPreferences _prefs;
  final LearningStageService _stageService;
  final CloudSyncService _cloudSync;

  int _gems = 0;
  int _xp = 0;
  int _currentLevel = 1;
  int _lessonsCompleted = 0;
  final List<Stage> _stages = [];
  final List<String> _achievements = [];
  int _totalXpEarned = 0;
  int _totalGemsEarned = 0;

  LearningRepositoryImpl(
    this._prefs,
    this._cloudSync, [
    LearningStageService? stageService,
  ]) : _stageService = stageService ?? const LearningStageService();

  int _computeChecksum() => Object.hashAll([
    _gems,
    _xp,
    _totalGemsEarned,
    _totalXpEarned,
    _lessonsCompleted,
    _currentLevel,
    _checksumSalt,
  ]);

  void _saveChecksum() {
    _prefs.setInt('learning_integrity', _computeChecksum());
  }

  bool _verifyChecksum() {
    final stored = _prefs.getInt('learning_integrity');
    if (stored == null) return true; // first run, nothing to verify
    final expected = _computeChecksum();
    if (stored != expected) {
      AppLogger().warning(
        'Integrity check failed: stored=$stored expected=$expected',
      );
      return false;
    }
    return true;
  }

  @override
  int get gems => _gems;

  @override
  int get xp => _xp;

  @override
  int get currentLevel => _currentLevel;

  @override
  int get lessonsCompleted => _lessonsCompleted;

  @override
  List<Stage> get stages => List.unmodifiable(_stages);

  @override
  List<String> get achievements => List.unmodifiable(_achievements);

  @override
  int get totalXpEarned => _totalXpEarned;

  @override
  int get totalGemsEarned => _totalGemsEarned;

  @override
  Future<void> load() async {
    _gems = _prefs.getInt('learning_gems') ?? 0;
    _xp = _prefs.getInt('learning_xp') ?? 0;
    _currentLevel = _prefs.getInt('learning_level') ?? 1;
    _lessonsCompleted = _prefs.getInt('learning_lessons_completed') ?? 0;
    _totalXpEarned = _prefs.getInt('learning_total_xp') ?? 0;
    _totalGemsEarned = _prefs.getInt('learning_total_gems') ?? 0;

    if (!_verifyChecksum()) {
      AppLogger().warning('Integrity check failed — resetting economic values');
      _gems = 0;
      _xp = 0;
      _currentLevel = 1;
      _totalXpEarned = 0;
      _totalGemsEarned = 0;
      _lessonsCompleted = 0;
    }

    final raw = _prefs.getString('learning_stages');
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        _stages
          ..clear()
          ..addAll(list.map((j) => Stage.fromJson(j as Map<String, dynamic>)));
      } catch (_) {
        _stages.clear();
      }
    } else {
      _stages.clear();
    }

    final ach = _prefs.getString('learning_achievements') ?? '';
    _achievements
      ..clear()
      ..addAll(ach.split(',').where((s) => s.isNotEmpty));
  }

  @override
  Future<List<Stage>> fetchStages() async {
    try {
      final fresh = await _stageService.fetchStages();
      if (fresh.isNotEmpty) return fresh;
    } catch (_) {}
    return [];
  }

  void _notifyFieldChanged(String key, int value) {
    try {
      _cloudSync.notifyFieldChanged(key, value);
    } catch (_) {}
  }

  @override
  void saveStages(List<Stage> stages) {
    _stages
      ..clear()
      ..addAll(stages);
    _prefs.setString(
      'learning_stages',
      jsonEncode(stages.map((s) => s.toJson()).toList()),
    );
  }

  @override
  void saveGems(int amount) {
    _gems = amount;
    _prefs.setInt('learning_gems', amount);
    _notifyFieldChanged('learning_gems', amount);
  }

  @override
  void saveXp(int amount) {
    _xp = amount;
    _prefs.setInt('learning_xp', amount);
    _notifyFieldChanged('learning_xp', amount);
  }

  @override
  void saveLevel(int level) {
    _currentLevel = level;
    _prefs.setInt('learning_level', level);
    _notifyFieldChanged('learning_level', level);
  }

  @override
  void saveLessonsCompleted(int count) {
    _lessonsCompleted = count;
    _prefs.setInt('learning_lessons_completed', count);
  }

  @override
  void saveAchievements(List<String> achievements) {
    _achievements
      ..clear()
      ..addAll(achievements);
    _prefs.setString('learning_achievements', achievements.join(','));
  }

  @override
  void saveTotalXp(int amount) {
    _totalXpEarned = amount;
    _prefs.setInt('learning_total_xp', amount);
    _notifyFieldChanged('learning_total_xp', amount);
  }

  @override
  void saveTotalGems(int amount) {
    _totalGemsEarned = amount;
    _prefs.setInt('learning_total_gems', amount);
    _notifyFieldChanged('learning_total_gems', amount);
  }

  @override
  void saveIntegrity() {
    _saveChecksum();
  }

  @override
  bool spendGems(int amount) {
    if (_gems < amount) return false;
    _gems -= amount;
    _prefs.setInt('learning_gems', _gems);
    _notifyFieldChanged('learning_gems', _gems);
    return true;
  }

  @override
  void addGems(int amount, {bool trackTotal = true}) {
    _gems += amount;
    _prefs.setInt('learning_gems', _gems);
    _notifyFieldChanged('learning_gems', _gems);
    if (trackTotal) {
      _totalGemsEarned += amount;
      _prefs.setInt('learning_total_gems', _totalGemsEarned);
      _notifyFieldChanged('learning_total_gems', _totalGemsEarned);
    }
  }

  @override
  void addXp(int amount, {bool trackTotal = true}) {
    _xp += amount;
    _prefs.setInt('learning_xp', _xp);
    _notifyFieldChanged('learning_xp', _xp);
    if (trackTotal) {
      _totalXpEarned += amount;
      _prefs.setInt('learning_total_xp', _totalXpEarned);
      _notifyFieldChanged('learning_total_xp', _totalXpEarned);
    }
  }
}
