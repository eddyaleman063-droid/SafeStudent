import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/shop_provider.dart';
import 'package:sagen/ui/widgets/store/buy_button.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final int gems;
  final bool dark;
  final VoidCallback onBuy;
  const ShopItemCard({super.key, required this.item, required this.gems, required this.dark, required this.onBuy});

  IconData _iconFor(String asset) {
    switch (asset) {
      case 'palette': return Icons.palette_rounded;
      case 'frame': return Icons.filter_frames_rounded;
      default: return Icons.shield_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final owned = item.isOwned;
    final canAfford = gems >= item.cost;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: owned
            ? PremiumColors.success.withValues(alpha: 0.05)
            : (dark ? PremiumColors.darkCard : Colors.white),
        border: Border.all(
          color: owned
              ? PremiumColors.success.withValues(alpha: 0.2)
              : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
        ),
        boxShadow: AppShadows.card(color: dark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: owned
                  ? PremiumColors.success.withValues(alpha: 0.1)
                  : PremiumColors.primaryAccent.withValues(alpha: 0.1),
            ),
            child: Icon(
              _iconFor(item.iconAsset),
              color: owned ? PremiumColors.success : PremiumColors.primaryAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owned ? '${item.name} ✓' : item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 12, color: dark ? Colors.white38 : Colors.black45),
                ),
              ],
            ),
          ),
          if (owned)
            const SizedBox(
              width: 78,
              child: Text(
                'Adquirido',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PremiumColors.success),
              ),
            )
          else
            BuyButton(
              cost: item.cost,
              canBuy: canAfford,
              dark: dark,
              onBuy: onBuy,
            ),
        ],
      ),
    );
  }
}
