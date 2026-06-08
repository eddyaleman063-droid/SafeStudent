import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/admob_service.dart';
import 'package:sagen/services/analytics_service.dart';
import 'package:sagen/services/experience_service.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';

class RewardedAdCard extends ConsumerWidget {
  final bool dark;
  const RewardedAdCard({super.key, required this.dark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final adService = ref.watch(admobServiceProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          gradient: LinearGradient(
            colors: [
              PremiumColors.splashBlue.withValues(alpha: 0.15),
              PremiumColors.xpColor.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: PremiumColors.splashBlue.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: PremiumColors.splashBlue.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.play_circle_rounded, color: PremiumColors.splashBlue, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.rewardAdTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.rewardAdSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: adService.isAdReady
                    ? () => _watchAd(context, ref, adService)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PremiumColors.splashBlue,
                  disabledBackgroundColor: dark ? Colors.white12 : Colors.black12,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                ),
                child: Text(
                  adService.isLoading ? l.sessionLoading : l.rewardAdWatch,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _watchAd(BuildContext context, WidgetRef ref, AdMobService adService) {
    final l = AppLocalizations.of(context)!;
    ExperienceService.instance.lightHaptic();
    final shown = adService.showAd(
      onUserEarnedReward: () {
        AnalyticsService.instance.trackAdRewardClaimed();
        ref.read(learningProvider.notifier).addGems(10);
        ref.read(loggerProvider).info('Rewarded ad: user earned 10 gems');
        if (context.mounted) {
          SagenNotification.show(context, message: l.rewardAdEarned(10));
        }
      },
    );
    if (!shown && context.mounted) {
      SagenNotification.show(context, message: l.rewardAdNotAvailable);
    }
  }
}
