import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sagen_pass.dart';
import '../services/storage_service.dart';
import 'service_providers.dart';

final sagenPassProvider = NotifierProvider<SagenPassNotifier, SagenPass>(
  SagenPassNotifier.new,
);

class SagenPassNotifier extends Notifier<SagenPass> {
  late final StorageService _storage;

  static const _keyPass = 'sagen_pass_v1';

  @override
  SagenPass build() {
    _storage = ref.watch(storageServiceProvider);
    return _load();
  }

  SagenPass _load() {
    final raw = _storage.getString(_keyPass);
    if (raw.isNotEmpty) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        return SagenPass(
          currentLevel: data['level'] as int? ?? 1,
          currentSP: data['sp'] as int? ?? 0,
          claimedLevels: (data['claimed'] as List?)?.cast<int>() ?? [],
          seasonStart: DateTime.tryParse(data['seasonStart'] as String? ?? '') ?? DateTime(2026),
        );
      } catch (_) {}
    }
    return SagenPass(
      seasonStart: DateTime.now(),
    );
  }

  void _save() {
    _storage.setString(_keyPass, jsonEncode({
      'level': state.currentLevel,
      'sp': state.currentSP,
      'claimed': state.claimedLevels,
      'seasonStart': state.seasonStart.toIso8601String(),
      'duration': state.seasonDurationDays,
    }));
  }

  void addSP(int amount) {
    if (state.isMaxLevel) return;
    final newSP = state.currentSP + amount;
    int newLevel = state.currentLevel;
    int remainingSP = newSP;
    while (remainingSP >= _spForLevel(newLevel) && newLevel < SagenPass.maxLevel) {
      remainingSP -= _spForLevel(newLevel);
      newLevel++;
    }
    state = state.copyWith(
      currentSP: remainingSP,
      currentLevel: newLevel,
    );
    _save();
  }

  int _spForLevel(int level) => 50 + (level - 1) * 10;

  bool claimLevel(int level) {
    if (state.isLevelClaimed(level)) return false;
    if (level > state.currentLevel) return false;
    final claimed = [...state.claimedLevels, level];
    state = state.copyWith(claimedLevels: claimed);
    _save();
    return true;
  }

  PassLevel? getLevel(int level) {
    try {
      return SagenPass.allLevels.firstWhere((l) => l.level == level);
    } catch (_) {
      return null;
    }
  }
}
