import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'storage_service.dart';

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool unlocked;
  DateTime? unlockedDate;
  final int xpReward;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlocked = false,
    this.unlockedDate,
    required this.xpReward,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'unlocked': unlocked,
    'unlockedDate': unlockedDate?.toIso8601String(),
  };
}

class AchievementService {
  static final AchievementService _instance = AchievementService._();
  static AchievementService get instance => _instance;
  AchievementService._();

  late StorageService _storage;
  List<AchievementModel> _achievements = [];

  static const _key = 'achievements_data';

  List<AchievementModel> get achievements => List.unmodifiable(_achievements);
  int get unlockedCount => _achievements.where((a) => a.unlocked).length;
  int get totalCount => _achievements.length;
  double get progress => totalCount > 0 ? unlockedCount / totalCount : 0;

  List<AchievementModel> get _templates => [
    AchievementModel(id: 'first_lesson', title: 'Primer Escudo', description: 'Completa tu primera lección', icon: Icons.shield_rounded, xpReward: 10),
    AchievementModel(id: 'five_lessons', title: 'Aprendiz', description: 'Completa 5 lecciones', icon: Icons.school_rounded, xpReward: 25),
    AchievementModel(id: 'ten_lessons', title: 'Estudiante Digital', description: 'Completa 10 lecciones', icon: Icons.auto_stories_rounded, xpReward: 40),
    AchievementModel(id: 'twenty_five_lessons', title: 'Guardián', description: 'Completa 25 lecciones', icon: Icons.verified_rounded, xpReward: 60),
    AchievementModel(id: 'fifty_lessons', title: 'Ciber Guardián', description: 'Completa 50 lecciones', icon: Icons.shield_rounded, xpReward: 100),
    AchievementModel(id: 'stage_complete', title: 'Conquistador', description: 'Completa tu primera etapa', icon: Icons.flag_rounded, xpReward: 30),
    AchievementModel(id: 'all_stages', title: 'Maestro Digital', description: 'Completa todas las etapas', icon: Icons.workspace_premium_rounded, xpReward: 200),
    AchievementModel(id: 'streak_3', title: 'Constante', description: '3 días de racha', icon: Icons.local_fire_department_rounded, xpReward: 20),
    AchievementModel(id: 'streak_7', title: 'Semana Digital', description: '7 días de racha', icon: Icons.local_fire_department_rounded, xpReward: 50),
    AchievementModel(id: 'streak_30', title: 'Racha Legendaria', description: '30 días de racha', icon: Icons.local_fire_department_rounded, xpReward: 100),
    AchievementModel(id: 'perfect_lesson', title: 'Perfecto', description: 'Completa una lección sin errores', icon: Icons.auto_awesome_rounded, xpReward: 30),
    AchievementModel(id: 'sage_talk', title: 'Curioso', description: 'Habla con Sage 10 veces', icon: Icons.smart_toy_rounded, xpReward: 40),
  ];

  Future<void> init(SharedPreferences prefs) async {
    _storage = StorageService(prefs);
    _load();
  }

  void _load() {
    final templates = _templates;
    final raw = _storage.getString(_key);
    if (raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        _achievements = list.map((item) {
          final map = item as Map<String, dynamic>;
          final id = map['id'] as String;
          final template = templates.firstWhere((t) => t.id == id);
          return AchievementModel(
            id: template.id,
            title: template.title,
            description: template.description,
            icon: template.icon,
            xpReward: template.xpReward,
            unlocked: map['unlocked'] as bool? ?? false,
            unlockedDate: map['unlockedDate'] != null ? DateTime.tryParse(map['unlockedDate'] as String) : null,
          );
        }).toList();
        return;
      } catch (_) {}
    }
    _achievements = templates.map((t) => AchievementModel(
      id: t.id, title: t.title, description: t.description,
      icon: t.icon, xpReward: t.xpReward,
    )).toList();
  }

  void _save() {
    _storage.setString(_key, jsonEncode(_achievements.map((a) => a.toJson()).toList()));
  }

  AchievementModel? getById(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  bool unlock(String id) {
    final achievement = getById(id);
    if (achievement == null || achievement.unlocked) return false;
    achievement.unlocked = true;
    achievement.unlockedDate = DateTime.now();
    _save();
    return true;
  }
}
