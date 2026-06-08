import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/services/achievement_service.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final bool dark;
  const AchievementCard({super.key, required this.achievement, required this.dark});

  static const _rarityGradients = <int, List<Color>>{
    10: [Color(0xFF90A4AE), Color(0xFFB0BEC5)],
    20: [Color(0xFF90A4AE), Color(0xFFCFD8DC)],
    25: [Color(0xFFFFB300), Color(0xFFFFD54F)],
    30: [Color(0xFFFFB300), Color(0xFFFFCA28)],
    40: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    50: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    60: [Color(0xFFFF6F00), Color(0xFFFFB300)],
    100: [Color(0xFFFF6F00), Color(0xFFFFD54F)],
    200: [Color(0xFFFF6F00), Color(0xFFFFE082)],
  };

  List<Color> get _gradient {
    for (final entry in _rarityGradients.entries) {
      if (achievement.xpReward <= entry.key) return entry.value;
    }
    return _rarityGradients.values.last;
  }

  String _rarityLabel(AppLocalizations l) {
    if (achievement.xpReward <= 20) return l.raritySilver;
    if (achievement.xpReward <= 40) return l.rarityGold;
    return l.rarityPlatinum;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final unlocked = achievement.unlocked;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: unlocked
            ? const Color(0xFF253145)
            : (dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03)),
        border: Border.all(
          color: unlocked
              ? _gradient.first.withValues(alpha: 0.2)
              : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  gradient: unlocked ? LinearGradient(colors: _gradient) : null,
                  color: unlocked
                      ? null
                      : (dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                ),
                child: Icon(
                  achievement.icon,
                  size: 20,
                  color: unlocked
                      ? Colors.white
                      : (dark ? Colors.white24 : Colors.black26),
                ),
              ),
              if (!unlocked)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Icon(Icons.lock_rounded, size: 12, color: dark ? Colors.white24 : Colors.black26),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: unlocked
                  ? (dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87)
                  : (dark ? Colors.white38 : Colors.black38),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unlocked ? achievement.description : l.achievementLocked,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: unlocked
                  ? (dark ? Colors.white38 : Colors.black45)
                  : (dark ? Colors.white12 : Colors.black12),
            ),
          ),
          if (unlocked) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                gradient: LinearGradient(colors: _gradient),
              ),
              child: Text(
                _rarityLabel(l),
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
