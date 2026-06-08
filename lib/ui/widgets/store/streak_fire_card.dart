import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/shop_provider.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/experience_service.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import 'package:sagen/ui/widgets/store/buy_button.dart';

class StreakFireCard extends ConsumerWidget {
  final ShopState shop;
  final dynamic learning;
  final dynamic streak;
  final bool dark;
  const StreakFireCard({super.key, required this.shop, required this.learning, required this.streak, required this.dark});

  Color get _fireColor {
    final curStreak = streak.currentStreak as int? ?? 0;
    final isFrozen = streak.isStreakFrozen as bool? ?? false;
    if (isFrozen) return PremiumColors.premiumIce;
    if (curStreak > 0) return PremiumColors.streakOrange;
    return dark ? Colors.white24 : Colors.black26;
  }

  String _fireStatusText(AppLocalizations l) {
    final curStreak = streak.currentStreak as int? ?? 0;
    final isFrozen = streak.isStreakFrozen as bool? ?? false;
    if (isFrozen) return l.streakFrozen;
    if (curStreak > 0) return l.streakDaysCount(curStreak);
    return l.streakNoActiveStreak;
  }

  Color get _statusColor {
    final curStreak = streak.currentStreak as int? ?? 0;
    final isFrozen = streak.isStreakFrozen as bool? ?? false;
    if (isFrozen) return PremiumColors.premiumIce;
    if (curStreak > 0) return PremiumColors.streakOrange;
    return dark ? Colors.white24 : Colors.black26;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final canBuy = shop.canBuyShield && learning.gems >= shop.shieldCost;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: [
            _fireColor.withValues(alpha: 0.1),
            (dark ? PremiumColors.darkCard : Colors.white).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _fireColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: _fireColor.withValues(alpha: 0.15),
            ),
            child: Icon(Icons.local_fire_department_rounded, color: _fireColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.streakFreeze,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.streakFreezeDescription,
                  style: TextStyle(fontSize: 12, color: dark ? Colors.white38 : Colors.black45),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 12, color: _fireColor),
                    const SizedBox(width: 4),
                    Text(
                      _fireStatusText(l),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          BuyButton(
            cost: shop.shieldCost,
            canBuy: canBuy,
            dark: dark,
            onBuy: () => _buyFreeze(context, ref),
          ),
        ],
      ),
    );
  }

  void _buyFreeze(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final exp = ExperienceService.instance;
    if (!shop.canBuyShield) {
      exp.errorHaptic();
      if (context.mounted) {
        SagenNotification.show(context, message: l.storeShieldLimitReached, type: NotificationType.error);
      }
      return;
    }
    if (learning.gems < shop.shieldCost) {
      exp.errorHaptic();
      if (context.mounted) {
        SagenNotification.show(context, message: l.storeNotEnoughGems, type: NotificationType.error);
      }
      return;
    }
    ref.read(learningProvider.notifier).spendGems(shop.shieldCost);
    ref.read(shopProvider.notifier).buyStreakShield();
    exp.successHaptic();
    if (context.mounted) {
      SagenNotification.show(context, message: l.storePurchaseSuccess, type: NotificationType.success);
    }
  }
}
