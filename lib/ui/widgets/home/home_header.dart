import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final String displayName;
  final int streak;
  final int gems;
  final String greeting;

  const HomeHeader({
    super.key,
    required this.displayName,
    required this.streak,
    required this.gems,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        MediaQuery.of(context).padding.top + AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: PremiumColors.splashBlue.withValues(alpha: 0.2),
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: PremiumColors.splashBlue,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  displayName.isNotEmpty ? displayName : l.homeDefaultName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _Pill(
            icon: Icons.local_fire_department_rounded,
            value: '$streak',
            label: l.daysLabel,
          ),
          const SizedBox(width: AppSpacing.sm),
          _Pill(
            icon: Icons.diamond_rounded,
            value: '$gems',
            label: l.profileGems,
          ),
        ],
      ),
    );
  }

  String get _initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || displayName.trim().isEmpty) return 'G';
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _Pill({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
