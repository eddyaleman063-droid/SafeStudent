import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chest_reward.dart';
import '../models/chest_type.dart';
import '../models/daily_mission.dart';
import '../services/chest_event_bus.dart';
import '../services/storage_service.dart';
import 'prefs_provider.dart';

class MissionState {
  final List<DailyMission> missions;
  final DateTime lastReset;
  final int totalMissionsCompleted;

  MissionState({
    this.missions = const [],
    DateTime? lastReset,
    this.totalMissionsCompleted = 0,
  }) : lastReset = lastReset ?? DateTime(0);

  MissionState copyWith({
    List<DailyMission>? missions,
    DateTime? lastReset,
    int? totalMissionsCompleted,
  }) {
    return MissionState(
      missions: missions ?? this.missions,
      lastReset: lastReset ?? this.lastReset,
      totalMissionsCompleted:
          totalMissionsCompleted ?? this.totalMissionsCompleted,
    );
  }
}

class MissionNotifier extends Notifier<MissionState> {
  late final StorageService _storage;

  List<DailyMission> get missions => List.unmodifiable(state.missions);
  int get totalMissionsCompleted => state.totalMissionsCompleted;
  int get completedToday => state.missions.where((m) => m.completed).length;

  static const _keyMissions = 'daily_missions_v2';
  static const _keyReset = 'daily_missions_reset';
  static const _keyTotal = 'daily_missions_total';

  @override
  MissionState build() {
    _storage = StorageService(ref.watch(prefsProvider));
    _load();
    _checkReset();
    return state;
  }

  void _load() {
    final raw = _storage.getString(_keyMissions);
    List<DailyMission> missions = [];
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          missions = decoded
              .map((e) => DailyMission.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
    }
    final resetStr = _storage.getString(_keyReset);
    DateTime lastReset = DateTime.now();
    if (resetStr.isNotEmpty) {
      lastReset = DateTime.tryParse(resetStr) ?? DateTime.now();
    }
    final total = _storage.getInt(_keyTotal);

    state = MissionState(
      missions: missions,
      lastReset: lastReset,
      totalMissionsCompleted: total,
    );
    if (missions.isEmpty) {
      _generateMissions();
    }
  }

  void _save() {
    state = state.copyWith();
    _storage.setString(
      _keyMissions,
      jsonEncode(state.missions.map((m) => m.toJson()).toList()),
    );
    _storage.setString(_keyReset, state.lastReset.toIso8601String());
    _storage.setInt(_keyTotal, state.totalMissionsCompleted);
  }

  void _checkReset() {
    final now = DateTime.now();
    final reset = DateTime(
      state.lastReset.year,
      state.lastReset.month,
      state.lastReset.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    if (today.isAfter(reset)) {
      _generateMissions();
      state = state.copyWith(lastReset: now);
      _save();
    }
  }

  void _generateMissions() {
    final daySeed = DateTime.now().day;
    final allMissions = [
      DailyMission(
        id: 'm1',
        title: 'Lección perfecta',
        description: 'Completa una lección sin errores.',
        type: MissionType.perfectLesson,
        target: 1,
        xpReward: 40,
        gemReward: 15,
        difficulty: MissionDifficulty.hard,
        rarity: MissionRarity.rare,
        xpBonus: 10,
        gemBonus: 5,
        category: MissionCategory.learning,
      ),
      DailyMission(
        id: 'm2',
        title: 'Aprendiz activo',
        description: 'Completa 1 lección de seguridad.',
        type: MissionType.completeLesson,
        target: 1,
        xpReward: 30,
        gemReward: 10,
        difficulty: MissionDifficulty.easy,
        rarity: MissionRarity.common,
        category: MissionCategory.learning,
      ),
      DailyMission(
        id: 'm3',
        title: 'Detective digital',
        description: 'Analiza un enlace sospechoso.',
        type: MissionType.analyzeLink,
        target: 1,
        xpReward: 25,
        gemReward: 8,
        difficulty: MissionDifficulty.easy,
        rarity: MissionRarity.common,
        category: MissionCategory.protection,
      ),
      DailyMission(
        id: 'm4',
        title: 'Conversa con Sage',
        description:
            'Habla con Sage sobre seguridad digital.',
        type: MissionType.talkToSage,
        target: 1,
        xpReward: 20,
        gemReward: 5,
        difficulty: MissionDifficulty.easy,
        rarity: MissionRarity.common,
        category: MissionCategory.awareness,
      ),
      DailyMission(
        id: 'm5',
        title: 'Racha activa',
        description: 'Mantén tu racha de aprendizaje hoy.',
        type: MissionType.maintainStreak,
        target: 1,
        xpReward: 35,
        gemReward: 12,
        difficulty: MissionDifficulty.medium,
        rarity: MissionRarity.rare,
        xpBonus: 5,
        gemBonus: 3,
        streakBonus: 1,
        category: MissionCategory.consistency,
      ),
      DailyMission(
        id: 'm6',
        title: 'Desafío exprés',
        description:
            'Completa un desafío rápido de 30 segundos.',
        type: MissionType.quickChallenge,
        target: 1,
        xpReward: 20,
        gemReward: 6,
        difficulty: MissionDifficulty.easy,
        rarity: MissionRarity.common,
        category: MissionCategory.learning,
      ),
      DailyMission(
        id: 'm7',
        title: 'Cazador de phishing',
        description:
            'Detecta correctamente un intento de phishing.',
        type: MissionType.detectPhishing,
        target: 1,
        xpReward: 45,
        gemReward: 15,
        difficulty: MissionDifficulty.hard,
        rarity: MissionRarity.epic,
        xpBonus: 15,
        gemBonus: 7,
        category: MissionCategory.privacy,
      ),
      DailyMission(
        id: 'm8',
        title: '3 consultas',
        description:
            'Habla 3 veces con Sage sobre temas distintos.',
        type: MissionType.talkToSage,
        target: 3,
        xpReward: 50,
        gemReward: 18,
        difficulty: MissionDifficulty.medium,
        rarity: MissionRarity.rare,
        xpBonus: 10,
        gemBonus: 5,
        category: MissionCategory.awareness,
      ),
      DailyMission(
        id: 'm9',
        title: 'Protector consistente',
        description: 'Completa 3 lecciones hoy.',
        type: MissionType.completeLesson,
        target: 3,
        xpReward: 60,
        gemReward: 20,
        difficulty: MissionDifficulty.hard,
        rarity: MissionRarity.epic,
        xpBonus: 20,
        gemBonus: 8,
        streakBonus: 2,
        category: MissionCategory.consistency,
      ),
    ];

    final startIdx = daySeed % allMissions.length;
    state = state.copyWith(missions: [
      allMissions[startIdx % allMissions.length],
      allMissions[(startIdx + 3) % allMissions.length],
      allMissions[(startIdx + 6) % allMissions.length],
    ]);
  }

  void advanceMission(MissionType type, {int amount = 1}) {
    final missions = state.missions;
    final idx = missions.indexWhere((m) => m.type == type && !m.completed);
    if (idx == -1) return;

    final mission = missions[idx];
    final newProgress = mission.progress + amount;
    final newCompleted = newProgress >= mission.target;

    final newMissions = List<DailyMission>.from(missions);
    newMissions[idx] = mission.copyWith(
      progress: newProgress,
      completed: newCompleted,
    );

    state = state.copyWith(
      missions: newMissions,
      totalMissionsCompleted:
          state.totalMissionsCompleted + (newCompleted ? 1 : 0),
    );
    _save();

    if (newCompleted) _rewardMission(mission);
  }

  void _rewardMission(DailyMission mission) {
    final roll = math.Random().nextDouble();

    ChestType? chestType;
    String label;

    if (roll < 0.01) {
      chestType = ChestType.legendary;
      label = '¡Legendario!';
    } else if (roll < 0.06) {
      chestType = ChestType.gold;
      label = '¡Oro!';
    } else if (roll < 0.20) {
      chestType = ChestType.silver;
      label = '¡Plata!';
    } else if (roll < 0.45) {
      chestType = ChestType.bronze;
      label = '¡Bronce!';
    } else {
      label = 'Recompensa';
    }

    if (chestType != null) {
      final reward = ChestRewardRoller.roll(chestType);
      ChestEventBus.instance.fire(ChestRewardData(
        type: chestType,
        xp: reward.xp,
        gems: reward.gems,
        streakShields: reward.streakShields,
        xpBoost: reward.xpBoost,
        gemMultiplier: reward.gemMultiplier,
        title: '$label Misión completada',
        message: 'Al completar "${mission.title}" has obtenido un cofre.',
        source: 'mission',
      ));
    }
  }

  void reload() {
    _load();
    _checkReset();
  }
}
