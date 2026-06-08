import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';

class CurrentUserRankBar extends StatelessWidget {
  final int rank;
  final int totalXp;
  final int xpToNext;

  const CurrentUserRankBar({
    super.key,
    required this.rank,
    required this.totalXp,
    required this.xpToNext,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: dark ? PremiumColors.darkCard.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95),
        border: Border.all(color: PremiumColors.splashBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_rounded, size: 20, color: PremiumColors.splashBlue),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.rankingYourPosition(rank, _formatXp(totalXp)),
                style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              if (xpToNext > 0)
                Text(
                  l.rankingXpToTop50(_formatXp(xpToNext)),
                  style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.45) : Colors.black54, fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) return '${(xp / 1000).toStringAsFixed(1)}k';
    return xp.toString();
  }
}
