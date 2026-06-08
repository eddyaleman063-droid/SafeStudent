import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/leaderboard_provider.dart';

class PodiumWidget extends StatelessWidget {
  final List<LeaderboardEntry> top3;

  const PodiumWidget({super.key, required this.top3});

  @override
  Widget build(BuildContext context) {
    if (top3.isEmpty) return const SizedBox.shrink();

    final first = top3.isNotEmpty ? top3[0] : null;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (second != null)
                  Expanded(child: _PodiumAvatar(entry: second, rank: 2, color: const Color(0xFFC0C0C0), height: 140)),
                if (first != null)
                  Expanded(child: _PodiumAvatar(entry: first, rank: 1, color: const Color(0xFFFFD700), height: 180, crown: true)),
                if (third != null)
                  Expanded(child: _PodiumAvatar(entry: third, rank: 3, color: const Color(0xFFCD7F32), height: 110)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final Color color;
  final double height;
  final bool crown;

  const _PodiumAvatar({
    required this.entry,
    required this.rank,
    required this.color,
    required this.height,
    this.crown = false,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (crown)
          Icon(Icons.workspace_premium_rounded, color: color, size: 28),
        const SizedBox(height: 4),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.5),
          ),
          child: CircleAvatar(
            backgroundColor: dark ? PremiumColors.darkCard : Colors.grey.shade200,
            child: Text(_initials, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: Text(
            entry.displayName.isNotEmpty ? entry.displayName.split(' ').first : '???',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          '${_formatXp(entry.totalXp)} XP',
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(width: 48, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 4),
      ],
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) return '${(xp / 1000).toStringAsFixed(1)}k';
    return xp.toString();
  }
}
