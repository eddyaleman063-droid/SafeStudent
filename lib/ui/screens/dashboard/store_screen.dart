import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/experience_service.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import 'package:sagen/ui/widgets/store/header.dart';
import 'package:sagen/ui/widgets/store/streak_fire_card.dart';
import 'package:sagen/ui/widgets/store/shop_item_card.dart';
import 'package:sagen/ui/widgets/store/gems_shop_section.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  void _buyItem(
    BuildContext context,
    String id,
    int cost,
    int gems,
    bool dark,
  ) {
    final exp = ExperienceService.instance;
    if (gems < cost) {
      exp.errorHaptic();
      if (context.mounted) {
        SagenNotification.show(
          context,
          message: AppLocalizations.of(context)!.storeNotEnoughGems,
          type: NotificationType.error,
        );
      }
      return;
    }
    final success = ref.read(learningProvider.notifier).spendGemsAtomic(
      cost,
      () {
        final bought = ref.read(shopProvider.notifier).buyItem(id);
        if (bought) {
          _logTransaction(context, 'purchase', cost, id);
        }
        return bought;
      },
    );
    if (!success) {
      exp.errorHaptic();
      return;
    }
    exp.successHaptic();
    if (context.mounted) {
      SagenNotification.show(
        context,
        message: AppLocalizations.of(context)!.storePurchaseSuccess,
        type: NotificationType.success,
      );
    }
  }

  void _logTransaction(
    BuildContext context,
    String type,
    int amount,
    String itemId,
  ) {
    try {
      final uid = ref.read(authServiceProvider).currentUser?.uid;
      if (uid != null) {
        FirebaseFirestore.instance.collection('transaction_logs').add({
          'userId': uid,
          'type': type,
          'amount': amount,
          'itemId': itemId,
          'balanceAfter': ref.read(learningProvider).gems,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final learning = ref.watch(learningProvider);
    final gems = learning.gems;
    final shop = ref.watch(shopProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: SafeArea(
        child: RepaintBoundary(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: StoreHeader(gems: gems, dark: dark),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.md,
                  AppSpacing.xxl,
                  AppSpacing.md,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context)!.storeProtectStreak,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: dark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: StreakFireCard(
                    shop: shop,
                    learning: learning,
                    streak: streak,
                    dark: dark,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  0,
                  AppSpacing.xxl,
                  AppSpacing.md,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context)!.storeGetGems,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: dark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: GemsShopSection(dark: dark, ref: ref),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                  AppSpacing.md,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context)!.storePersonalization,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: dark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  0,
                  AppSpacing.xxl,
                  100,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final item = shop.items[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ShopItemCard(
                        item: item,
                        gems: learning.gems,
                        dark: dark,
                        onBuy: () => _buyItem(
                          ctx,
                          item.id,
                          item.cost,
                          learning.gems,
                          dark,
                        ),
                      ),
                    );
                  }, childCount: shop.items.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
