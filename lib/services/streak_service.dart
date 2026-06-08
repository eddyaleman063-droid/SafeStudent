import 'dart:math';
import 'storage_service.dart';

class StreakStatus {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final int streakFreezes;
  final bool isAtRisk;
  final String message;
  final String tier;

  const StreakStatus({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    required this.streakFreezes,
    required this.isAtRisk,
    required this.message,
    required this.tier,
  });

  bool get hasStreak => currentStreak > 0;
  bool get isStreakFrozen => streakFreezes > 0 && isAtRisk && currentStreak > 0;

  Duration get timeUntilMidnight {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }
}

class StreakService {
  final StorageService _storage;

  static const _keyCurrent = 'streak_current';
  static const _keyLongest = 'streak_longest';
  static const _keyLast = 'streak_last_activity';
  static const _keyFreezes = 'streak_freezes';

  StreakService(this._storage);

  StreakStatus load() {
    final current = _storage.getInt(_keyCurrent).clamp(0, 10000);
    final longest = _storage.getInt(_keyLongest).clamp(0, 10000);
    final freezes = _storage.getInt(_keyFreezes).clamp(0, 1000);

    final lastStr = _storage.getString(_keyLast);
    final lastDate = lastStr.isNotEmpty ? DateTime.tryParse(lastStr) : null;

    return _evaluate(current, longest, lastDate, freezes);
  }

  void _save(int current, int longest, DateTime? lastDate, int freezes) {
    _storage.setInt(_keyCurrent, current);
    _storage.setInt(_keyLongest, longest);
    _storage.setString(_keyLast, lastDate?.toIso8601String() ?? '');
    _storage.setInt(_keyFreezes, freezes);
  }

  StreakStatus _evaluate(int current, int longest, DateTime? lastDate, int freezes) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int updatedCurrent = current;
    int updatedFreezes = freezes;
    DateTime? updatedLast = lastDate;

    if (lastDate != null) {
      final last = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = today.difference(last).inDays;

      if (diff >= 2) {
        if (freezes > 0 && diff == 2) {
          updatedFreezes--;
        } else {
          updatedCurrent = 0;
          updatedLast = null;
          updatedFreezes = 0;
        }
      }
    }

    final atRisk = updatedCurrent > 0 && lastDate != null &&
        today.difference(DateTime(lastDate.year, lastDate.month, lastDate.day)).inDays >= 1;

    final message = _buildMessage(updatedCurrent, atRisk);
    final tier = _tierFor(updatedCurrent);

    _save(updatedCurrent, max(updatedCurrent, longest), updatedLast, updatedFreezes);

    return StreakStatus(
      currentStreak: updatedCurrent,
      longestStreak: max(updatedCurrent, longest),
      lastActivityDate: updatedLast,
      streakFreezes: updatedFreezes,
      isAtRisk: atRisk,
      message: message,
      tier: tier,
    );
  }

  StreakStatus checkIn() {
    final current = _storage.getInt(_keyCurrent).clamp(0, 10000);
    final longest = _storage.getInt(_keyLongest).clamp(0, 10000);
    final freezes = _storage.getInt(_keyFreezes).clamp(0, 1000);
    final lastStr = _storage.getString(_keyLast);
    final lastDate = lastStr.isNotEmpty ? DateTime.tryParse(lastStr) : null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newFreezes = freezes + 1;

    int newCurrent;
    if (lastDate != null) {
      final last = DateTime(lastDate.year, lastDate.month, lastDate.day);
      if (today == last) {
        return _evaluate(current, longest, lastDate, freezes);
      }
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        newCurrent = current + 1;
      } else if (diff >= 2 && freezes > 0) {
        newCurrent = current + 1;
      } else {
        newCurrent = 1;
      }
    } else {
      newCurrent = 1;
    }

    final newLongest = max(newCurrent, longest);
    _save(newCurrent, newLongest, now, min(newFreezes, 7));

    return _evaluate(newCurrent, newLongest, now, min(newFreezes, 7));
  }

  String _buildMessage(int streak, bool atRisk) {
    if (atRisk) return '\u00a1Tu racha est\u00e1 en riesgo!';
    if (streak >= 100) return '100 d\u00edas. Leyenda.';
    if (streak >= 50) return '50 d\u00edas de protecci\u00f3n constante.';
    if (streak >= 30) return 'Un mes. Eres un Guardi\u00e1n Digital.';
    if (streak >= 14) return 'Dos semanas. Tu escudo brilla.';
    if (streak >= 7) return '\u00a1Una semana! Sigue as\u00ed.';
    if (streak >= 3) return '3 d\u00edas. Buen comienzo.';
    if (streak > 0) return '\u00a1Sigue protegi\u00e9ndote!';
    return 'Completa actividades para iniciar tu racha.';
  }

  String _tierFor(int streak) {
    if (streak >= 100) return 'legendary';
    if (streak >= 30) return 'crystal';
    if (streak >= 14) return 'particles';
    if (streak >= 7) return 'glow';
    if (streak >= 1) return 'basic';
    return 'inactive';
  }

  bool shouldSendReminder(StreakStatus status) {
    if (!status.hasStreak) return false;
    if (!status.isAtRisk) return false;
    return status.timeUntilMidnight.inHours <= 4 && status.timeUntilMidnight.inHours > 0;
  }
}
