import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/ad_manager_service.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';

class AdRewardCard extends ConsumerWidget {
  final bool dark;
  const AdRewardCard({super.key, required this.dark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: dark ? const Color(0xFF1A1F2E) : Colors.white,
        border: Border.all(color: dark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
        boxShadow: AppShadows.card(color: dark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.play_circle_rounded, color: Color(0xFF7C3AED), size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.storeAdEarnGem,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.storeAdWatchVideo,
                  style: TextStyle(fontSize: 12, color: dark ? Colors.white38 : Colors.black45),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              AdManagerService.instance.showRewardedAd(
                onReward: () {
                  ref.read(gamificationProvider.notifier).onAdRewardEarned();
                  if (context.mounted) {
                    SagenNotification.show(context, message: l.storeAdRewardMessage);
                  }
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: const Color(0xFF7C3AED),
              ),
              child: Text(
                l.storeWatch,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
