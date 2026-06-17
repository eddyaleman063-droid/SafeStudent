import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamificationRepository {
  final SharedPreferences _prefs;

  GamificationRepository(this._prefs);

  static const _keyLastClaim = 'gamification_last_claim_date';
  static const _keyUnclaimedChest = 'gamification_unclaimed_chest';
  static const _keyMissions = 'gamification_missions';
  // ── Daily Chest ──

  /// Returns today's date as YYYY-MM-DD in local timezone
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  /// Whether the user has an unclaimed daily chest
  bool get hasUnclaimedDailyChest {
    final stored = _prefs.getBool(_keyUnclaimedChest) ?? false;
    if (!stored) return false;
    // If stored date doesn't match today, the chest is from a previous day → expired
    final lastClaimDate = _prefs.getString(_keyLastClaim) ?? '';
    return lastClaimDate == _today();
  }

  /// Whether the user can claim a chest right now
  bool get canClaimDailyChest {
    final lastClaimDate = _prefs.getString(_keyLastClaim) ?? '';
    if (lastClaimDate.isNotEmpty && lastClaimDate.compareTo(_today()) > 0) {
      return false;
    }
    if (lastClaimDate != _today()) return true;
    return _prefs.getBool(_keyUnclaimedChest) ?? false;
  }

  /// Claim the daily chest. Returns the gem reward (2).
  /// Resets the unclaimed flag. Performs anti-cheat check.
  int claimDailyChest() {
    // Anti-cheat: check date before any mutations
    final storedDate = _prefs.getString(_keyLastClaim) ?? '';
    if (storedDate.isNotEmpty && storedDate.compareTo(_today()) > 0) {
      _prefs.setBool(_keyUnclaimedChest, false);
      throw PlatformException(
        code: 'CLOCK_MANIPULATION',
        message: 'Se detectó manipulación del reloj. No es posible reclamar el cofre.',
      );
    }

    // Handle new day
    if (storedDate != _today()) {
      _prefs.setBool(_keyUnclaimedChest, true);
      _prefs.setString(_keyLastClaim, _today());
    }

    if (!_prefs.getBool(_keyUnclaimedChest)!) {
      throw StateError('No chest available to claim today');
    }

    const reward = 2; // fixed: 2 gems per daily chest
    _prefs.setBool(_keyUnclaimedChest, false);
    return reward;
  }

  /// Midnight expiration check: if it's a new day and chest wasn't claimed,
  /// the previous chest is lost. This is called on app start.
  void checkMidnightReset() {
    final lastClaimDate = _prefs.getString(_keyLastClaim) ?? '';
    if (lastClaimDate.isNotEmpty && lastClaimDate != _today()) {
      final wasUnclaimed = _prefs.getBool(_keyUnclaimedChest) ?? false;
      if (wasUnclaimed) {
        // Chest expired — user lost it
        _prefs.setBool(_keyUnclaimedChest, false);
      }
    }
  }

  /// Returns seconds until midnight local time
  int get secondsUntilMidnight {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now).inSeconds;
  }

  // ── Missions ──

  Map<String, int> getMissions() {
    final raw = _prefs.getString(_keyMissions);
    if (raw == null) return {};
    try {
      return Map<String, int>.from(
        raw.split(',').fold<Map<String, int>>({}, (map, pair) {
          final parts = pair.split(':');
          if (parts.length == 2) {
            map[parts[0]] = int.tryParse(parts[1]) ?? 0;
          }
          return map;
        }),
      );
    } catch (_) {
      return {};
    }
  }

  void saveMissions(Map<String, int> missions) {
    final raw = missions.entries.map((e) => '${e.key}:${e.value}').join(',');
    _prefs.setString(_keyMissions, raw);
  }

  void incrementMission(String missionId, {int amount = 1}) {
    final missions = getMissions();
    missions[missionId] = (missions[missionId] ?? 0) + amount;
    saveMissions(missions);
  }

  bool isMissionComplete(String missionId, {int target = 1}) {
    final missions = getMissions();
    return (missions[missionId] ?? 0) >= target;
  }
}
