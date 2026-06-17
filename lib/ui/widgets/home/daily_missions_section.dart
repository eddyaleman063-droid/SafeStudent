import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_constants.dart';

class DailyMissionsSection extends ConsumerWidget {
  const DailyMissionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionProvider);

    if (missions.missions.every((m) => m.completed)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            color: context.surfaceCard,
            border: Border.all(
              color: context.subtleBorder,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.celebration_rounded, color: PremiumColors.warning, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  '¡Todos los desafíos completados hoy!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: context.surfaceCard,
          border: Border.all(
            color: context.subtleBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, size: 18, color: PremiumColors.warning),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Desafíos diarios',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${missions.missions.where((m) => m.completed).length}/${missions.missions.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: PremiumColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            ...missions.missions.map((m) => _MissionRow(mission: m)),
          ],
        ),
      ),
    );
  }
}

class _MissionRow extends StatelessWidget {
  final dynamic mission;

  const _MissionRow({required this.mission});

  Color _colorForRarity(BuildContext context) {
    final r = mission.rarity.toString();
    if (r.contains('epic')) return PremiumColors.warning;
    if (r.contains('rare')) return PremiumColors.primaryAccent;
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54);
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForRarity(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                mission.completed ? Icons.check_circle_rounded : Icons.task_alt_rounded,
                size: 16,
                color: mission.completed ? PremiumColors.success : color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  mission.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: mission.completed
                        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
                    decoration: mission.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (!mission.completed) ...[
                _RewardChip(value: '${mission.xpReward}', icon: Icons.auto_awesome_rounded, color: PremiumColors.xpColor),
                const SizedBox(width: AppSpacing.xs),
                _RewardChip(value: '${mission.gemReward}', icon: Icons.diamond_rounded, color: PremiumColors.primaryAccent),
              ],
            ],
          ),
          if (!mission.completed && mission.target > 1) ...[
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: mission.progressFraction,
                backgroundColor: context.shimmerBase,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '${mission.progress}/${mission.target}',
                style: TextStyle(
                  fontSize: 10,
                  color: context.textTertiary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  final String value;
  final IconData icon;
  final Color color;

  const _RewardChip({required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: color.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
