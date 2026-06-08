import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import 'package:sagen/ui/widgets/store/ad_reward_card.dart';
import 'package:sagen/ui/widgets/store/buy_gems_button.dart';
import 'package:sagen/ui/widgets/store/chest_card.dart';

class GemsShopSection extends StatelessWidget {
  final bool dark;
  final WidgetRef ref;
  const GemsShopSection({super.key, required this.dark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final gamificationState = ref.watch(gamificationProvider);

    return Column(
      children: [
        // Daily chest card
        ChestCard(
          dark: dark,
          hasUnclaimed: gamificationState.hasUnclaimedChest,
          onClaim: () {
            try {
              ref.read(gamificationProvider.notifier).claimDailyChest();
            } catch (e) {
              SagenNotification.show(context, message: e.toString());
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        // Ad reward button
        AdRewardCard(dark: dark),
        const SizedBox(height: AppSpacing.md),
        // Buy gems button
        BuyGemsButton(dark: dark),
      ],
    );
  }
}
