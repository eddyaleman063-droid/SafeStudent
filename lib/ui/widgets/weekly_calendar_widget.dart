import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';

class WeeklyCalendarWidget extends StatelessWidget {
  final int currentStreak;
  final int streakGoal;
  final Map<String, bool> weekDays;
  final bool isDark;

  const WeeklyCalendarWidget({
    super.key,
    required this.currentStreak,
    required this.streakGoal,
    required this.weekDays,
    required this.isDark,
  });

  static List<String> dayLabels(AppLocalizations l) => [
    l.dayShortMon, l.dayShortTue, l.dayShortWed, l.dayShortThu,
    l.dayShortFri, l.dayShortSat, l.dayShortSun,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final date = startOfWeek.add(Duration(days: i));
            final key = date.toIso8601String().substring(0, 10);
            final isCompleted = weekDays[key] ?? false;
            final isToday = date.day == now.day && date.month == now.month && date.year == now.year;

            return _DayCircle(
              label: dayLabels(l)[i],
              isCompleted: isCompleted,
              isToday: isToday,
              isDark: isDark,
              dayNumber: date.day,
            );
          }),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l.streakCurrentProgress(currentStreak, streakGoal),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isToday;
  final bool isDark;
  final int dayNumber;

  const _DayCircle({
    required this.label,
    required this.isCompleted,
    required this.isToday,
    required this.isDark,
    required this.dayNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? PremiumColors.streakOrange
                : isToday
                    ? PremiumColors.splashBlue.withValues(alpha: 0.2)
                    : Colors.transparent,
            border: isToday && !isCompleted
                ? Border.all(color: PremiumColors.splashBlue, width: 2)
                : null,
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday
                          ? PremiumColors.splashBlue
                          : isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          '$dayNumber',
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.25),
          ),
        ),
      ],
    );
  }
}
