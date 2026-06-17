import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/analytics_service.dart';
import '../services/cloud_sync_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';
import '../models/chest_type.dart';
import '../models/chest_reward.dart';
import '../services/chest_event_bus.dart';
import 'learning_provider.dart';
import 'service_providers.dart';

class StreakState {
  final StreakStatus status;
  final int totalCheckIns;
  final int perfectWeeks;
  final bool missionCompleted;
  final Map<String, int> weeklyStats;
  final Map<String, int> heatmapData;
  final Map<String, int> monthlyData;
  final List<String> streakHistory;
  final List<String> emotionalMessages;

  const StreakState({
    required this.status,
    required this.totalCheckIns,
    required this.perfectWeeks,
    required this.missionCompleted,
    required this.weeklyStats,
    required this.heatmapData,
    required this.monthlyData,
    required this.streakHistory,
    required this.emotionalMessages,
  });

  StreakState copyWith({
    StreakStatus? status,
    int? totalCheckIns,
    int? perfectWeeks,
    bool? missionCompleted,
    Map<String, int>? weeklyStats,
    Map<String, int>? heatmapData,
    Map<String, int>? monthlyData,
    List<String>? streakHistory,
    List<String>? emotionalMessages,
  }) {
    return StreakState(
      status: status ?? this.status,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      perfectWeeks: perfectWeeks ?? this.perfectWeeks,
      missionCompleted: missionCompleted ?? this.missionCompleted,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      heatmapData: heatmapData ?? this.heatmapData,
      monthlyData: monthlyData ?? this.monthlyData,
      streakHistory: streakHistory ?? this.streakHistory,
      emotionalMessages: emotionalMessages ?? this.emotionalMessages,
    );
  }

  int get currentStreak => status.currentStreak;
  bool get isStreakFrozen => status.isStreakFrozen;
}

class StreakNotifier extends Notifier<StreakState> {
  static int _staticStreak = 0;
  static int get currentStreakStatic => _staticStreak;
  late StreakService _service;
  late CloudSyncService _cloudSync;

  static const _missions = [
    'Aprende qué es el phishing',
    'Activa la autenticación en dos pasos',
    'Revisa tus contraseñas',
    'Identifica un enlace sospechoso',
    'Aprende sobre redes WiFi seguras',
    'Configura una contraseña segura',
    'Reconoce un correo fraudulento',
  ];

  static const _emotionalQuotes = [
    'Tu seguridad mejora cada día.',
    '7 días protegiendo tu identidad digital.',
    'Cada día cuenta para tu protección.',
    'Estás construyendo un hábito digital seguro.',
    'Tu escudo se fortalece día a día.',
    'La consistencia es tu mejor defensa.',
    'Sigue así. Tu esfuerzo de hoy protege tu mañana.',
  ];

  static const _keyTotalCheckIns = 'streak_total_checkins';
  static const _keyPerfectWeeks = 'streak_perfect_weeks';
  static const _keyHistory = 'streak_history';
  static const _keyWeeklyStats = 'streak_weekly_stats';
  static const _keyHeatmap = 'streak_heatmap';
  static const _keyMonthlyData = 'streak_monthly_data';

  @override
  StreakState build() {
    _service = ref.watch(streakServiceProvider);
    _cloudSync = ref.watch(cloudSyncServiceProvider);
    final status = _service.load();
    _staticStreak = status.currentStreak;
    return _loadState(status, ref.watch(storageServiceProvider));
  }

  StreakState _loadState(StreakStatus status, StorageService storage) {
    final totalCheckIns = storage.getInt(_keyTotalCheckIns).clamp(0, 100000);
    final perfectWeeks = storage.getInt(_keyPerfectWeeks).clamp(0, 1000);
    final raw = storage.getString(_keyHistory);
    final streakHistory = raw.isNotEmpty
        ? raw.split(',').where((s) => s.isNotEmpty).toList()
        : <String>[];
    final ws = storage.getString(_keyWeeklyStats);
    final weeklyStats = ws.isNotEmpty ? _parseStringMap(ws) : <String, int>{};
    final hm = storage.getString(_keyHeatmap);
    final heatmapData = hm.isNotEmpty ? _parseStringMap(hm) : <String, int>{};
    final md = storage.getString(_keyMonthlyData);
    final monthlyData = md.isNotEmpty ? _parseStringMap(md) : <String, int>{};
    final emotionalMessages = _computeEmotionalMessages(status);
    return StreakState(
      status: status,
      totalCheckIns: totalCheckIns,
      perfectWeeks: perfectWeeks,
      missionCompleted: false,
      weeklyStats: weeklyStats,
      heatmapData: heatmapData,
      monthlyData: monthlyData,
      streakHistory: streakHistory,
      emotionalMessages: emotionalMessages,
    );
  }

  Map<String, int> _parseStringMap(String raw) {
    final map = <String, int>{};
    if (raw.isEmpty) return map;
    for (final entry in raw.split(',')) {
      final parts = entry.split(':');
      if (parts.length == 2) map[parts[0]] = int.tryParse(parts[1]) ?? 0;
    }
    return map;
  }

  String _encodeStringMap(Map<String, int> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  List<String> _computeEmotionalMessages(StreakStatus status) {
    final msgs = <String>[];
    if (status.currentStreak >= 100) {
      msgs.add('100 días de protección constante. Leyenda.');
    } else if (status.currentStreak >= 50) {
      msgs.add('50 días de protección digital constante.');
    } else if (status.currentStreak >= 30) {
      msgs.add('Un mes de aprendizaje. Tu dedicación te convierte en Guardián Digital.');
    } else if (status.currentStreak >= 14) {
      msgs.add('Dos semanas de constancia. Tu escudo brilla con fuerza.');
    } else if (status.currentStreak >= 7) {
      msgs.add('Una semana protegiendo tu identidad digital. Sigue así.');
    } else if (status.currentStreak >= 3) {
      msgs.add('3 días seguidos. Estás construyendo un hábito sólido.');
    }
    if (msgs.isEmpty && status.currentStreak > 0) {
      msgs.addAll(_emotionalQuotes.take(2));
    }
    return msgs;
  }

  void _saveExtras(StorageService storage) {
    final s = state;
    storage.setInt(_keyTotalCheckIns, s.totalCheckIns);
    storage.setInt(_keyPerfectWeeks, s.perfectWeeks);
    storage.setString(_keyHistory, s.streakHistory.join(','));
    storage.setString(_keyWeeklyStats, _encodeStringMap(s.weeklyStats));
    storage.setString(_keyHeatmap, _encodeStringMap(s.heatmapData));
    storage.setString(_keyMonthlyData, _encodeStringMap(s.monthlyData));
  }

  void _syncStreakToFirestore() {
    try {
      _cloudSync.notifyFieldChanged('streak_current', state.status.currentStreak);
      _cloudSync.notifyFieldChanged('streak_longest', state.status.longestStreak);
    } catch (_) {}
  }

  void _checkAchievements(int oldStreak, StreakStatus newStatus) {
    final a = AnalyticsService.instance;
    if (newStatus.currentStreak >= 1 && oldStreak == 0) a.unlockAchievement(Achievement.shieldBasic);
    if (newStatus.currentStreak >= 7 && oldStreak < 7) a.unlockAchievement(Achievement.shieldGlow);
    if (newStatus.currentStreak >= 30 && oldStreak < 30) {
      a.unlockAchievement(Achievement.shieldCrystal);
      a.unlockAchievement(Achievement.cyberGuardian);
    }
    if (newStatus.currentStreak >= 100 && oldStreak < 100) a.unlockAchievement(Achievement.shieldLegendary);
    if (newStatus.currentStreak == 7) { a.unlockAchievement(Achievement.streak7); a.unlockAchievement(Achievement.perfectWeek); }
    if (newStatus.currentStreak == 14) a.unlockAchievement(Achievement.streak14);
    if (newStatus.currentStreak == 30) a.unlockAchievement(Achievement.streak30);
    if (newStatus.currentStreak == 100) a.unlockAchievement(Achievement.streak100);
    if (newStatus.currentStreak == 3) a.unlockAchievement(Achievement.streak3);
  }

  int _isoWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(startOfYear).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  // -- Public API: Getters --

  StreakStatus get status => state.status;
  int get currentStreak => state.status.currentStreak;
  int get longestStreak => state.status.longestStreak;
  DateTime? get lastActivityDate => state.status.lastActivityDate;
  int get streakFreezes => state.status.streakFreezes;
  bool get isAtRisk => state.status.isAtRisk;
  String get message => state.status.message;
  String get tier => state.status.tier;
  String get shieldTier => state.status.tier;
  bool get hasStreak => state.status.hasStreak;
  bool get isStreakFrozen => state.status.isStreakFrozen;

  int get totalCheckIns => state.totalCheckIns;
  int get perfectWeeks => state.perfectWeeks;
  bool get missionCompleted => state.missionCompleted;
  Map<String, int> get weeklyStats => Map.unmodifiable(state.weeklyStats);
  Map<String, int> get heatmapData => Map.unmodifiable(state.heatmapData);
  Map<String, int> get monthlyStats => Map.unmodifiable(state.monthlyData);
  List<String> get streakHistory => List.unmodifiable(state.streakHistory);
  List<String> get emotionalMessages => List.unmodifiable(state.emotionalMessages);

  String get currentMission => _missions[DateTime.now().day % _missions.length];

  Map<String, int> get monthlyStreakStats {
    final now = DateTime.now();
    final stats = <String, int>{};
    for (int i = 0; i < 6; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final key = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      stats[key] = state.monthlyData[key] ?? 0;
    }
    return stats;
  }

  String get shieldTierName {
    switch (tier) {
      case 'legendary': return 'Escudo Legendario';
      case 'crystal': return 'Escudo de Cristal';
      case 'particles': return 'Escudo de Partículas';
      case 'glow': return 'Escudo Radiante';
      case 'basic': return 'Escudo Básico';
      default: return 'Sin Escudo';
    }
  }

  // -- Public API: Mutations --

  void completeMission() {
    if (state.missionCompleted) return;
    state = state.copyWith(missionCompleted: true);
  }

  static const _keyJustDefrosted = 'streak_just_defrosted';

  void checkIn() {
    final wasFrozen = state.isStreakFrozen;
    final oldStreak = state.status.currentStreak;
    final newStatus = _service.checkIn();
    final newTotalCheckIns = state.totalCheckIns + 1;

    final now = DateTime.now();
    final weekKey = '${now.year}-W${_isoWeekNumber(now)}';
    final newWeeklyStats = Map<String, int>.from(state.weeklyStats);
    newWeeklyStats[weekKey] = (newWeeklyStats[weekKey] ?? 0) + 1;

    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final newMonthlyData = Map<String, int>.from(state.monthlyData);
    newMonthlyData[monthKey] = (newMonthlyData[monthKey] ?? 0) + 1;

    final heatmapKey = now.toIso8601String().substring(0, 10);
    final newHeatmap = Map<String, int>.from(state.heatmapData);
    newHeatmap[heatmapKey] = (newHeatmap[heatmapKey] ?? 0) + 1;
    final keys = newHeatmap.keys.toList()..sort();
    while (newHeatmap.length > 365) {
      newHeatmap.remove(keys.first);
    }

    _checkAchievements(oldStreak, newStatus);

    final newEmotions = _computeEmotionalMessages(newStatus);

    final newPerfectWeeks = (newStatus.currentStreak > 0 && newStatus.currentStreak % 7 == 0)
        ? state.perfectWeeks + 1
        : state.perfectWeeks;

    _checkStreakChest(oldStreak, newStatus);

    state = state.copyWith(
      status: newStatus,
      totalCheckIns: newTotalCheckIns,
      perfectWeeks: newPerfectWeeks,
      weeklyStats: newWeeklyStats,
      monthlyData: newMonthlyData,
      heatmapData: newHeatmap,
      emotionalMessages: newEmotions,
    );

    final storage = ref.read(storageServiceProvider);
    if (wasFrozen && !newStatus.isStreakFrozen) {
      storage.setBool(_keyJustDefrosted, true);
    }
    _saveExtras(storage);
    _syncStreakToFirestore();
    _scheduleStreakReminder();
  }

  void _checkStreakChest(int oldStreak, StreakStatus newStatus) {
    final newStreak = newStatus.currentStreak;
    if (newStreak <= oldStreak) return;

    if (newStreak == 7 || newStreak == 14 || newStreak == 30 || newStreak == 100) {
      final t = newStreak == 7
          ? ChestType.silver
          : newStreak == 14
              ? ChestType.gold
              : ChestType.legendary;
      final title = newStreak == 7
          ? '¡7 días de racha!'
          : newStreak == 14
              ? '¡14 días de racha!'
              : newStreak == 30
                  ? '¡30 días de racha!'
                  : '¡100 días de racha!';
      final message = newStreak == 7
          ? 'Una semana protegiendo tu identidad digital.'
          : newStreak == 14
              ? 'Dos semanas de constancia. Sigue así.'
              : newStreak == 30
                  ? 'Un mes. Eres un Guardián Digital.'
                  : '100 días. Leyenda.';

      final baseXp = newStreak >= 100 ? 100 : (newStreak >= 30 ? 60 : (newStreak >= 14 ? 30 : 20));
      final baseGems = newStreak >= 100 ? 30 : (newStreak >= 30 ? 20 : (newStreak >= 14 ? 10 : 5));

      final reward = ChestRewardRoller.roll(t, overrideXp: baseXp, overrideGems: baseGems);

      ref.read(learningProvider.notifier).addGems(reward.gems);
      ref.read(learningProvider.notifier).addXp(reward.xp);

      ChestEventBus.instance.fire(ChestRewardData(
        type: t,
        xp: reward.xp,
        gems: reward.gems,
        streakShields: reward.streakShields,
        xpBoost: reward.xpBoost,
        gemMultiplier: reward.gemMultiplier,
        title: title,
        message: message,
        source: 'streak',
      ));
    }
  }

  void _scheduleStreakReminder() {
    _staticStreak = state.status.currentStreak;
    NotificationService.instance.scheduleStreakReminder(_staticStreak);
  }

  void reload() {
    final newStatus = _service.load();
    _staticStreak = newStatus.currentStreak;
    state = state.copyWith(status: newStatus);
    _syncStreakToFirestore();
  }
}
