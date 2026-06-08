import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/leaderboard_provider.dart';

class RankingTileWidget extends StatelessWidget {
  final int rank;
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const RankingTileWidget({
    super.key,
    required this.rank,
    required this.entry,
    this.isCurrentUser = false,
  });

  String get _initials {
    final parts = entry.displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    if (parts.length == 1 && parts.first.isNotEmpty) return parts.first[0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: dark ? PremiumColors.darkCard.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.9),
        border: Border.all(
          color: isCurrentUser ? PremiumColors.splashBlue.withValues(alpha: 0.3) : dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: isCurrentUser ? PremiumColors.splashBlue : dark ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: isCurrentUser ? PremiumColors.splashBlue.withValues(alpha: 0.2) : dark ? PremiumColors.darkSurface : Colors.grey.shade200,
              child: Text(_initials, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: dark ? Colors.white.withValues(alpha: 0.8) : Colors.black54)),
            ),
          ],
        ),
        title: Text(
          entry.displayName.isNotEmpty ? entry.displayName : AppLocalizations.of(context)!.unknownLabel,
          style: TextStyle(
            color: isCurrentUser ? PremiumColors.splashBlue : dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
            fontSize: 14,
            fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, size: 16, color: PremiumColors.streakOrange.withValues(alpha: 0.8)),
            const SizedBox(width: 4),
            Text(
              _formatXp(entry.totalXp),
              style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.7) : Colors.black54, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        dense: true,
      ),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) return '${(xp / 1000).toStringAsFixed(1)}k';
    return xp.toString();
  }
}
