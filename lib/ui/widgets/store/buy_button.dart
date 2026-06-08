import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class BuyButton extends StatelessWidget {
  final int cost;
  final bool canBuy;
  final bool dark;
  final VoidCallback onBuy;
  const BuyButton({super.key, required this.cost, required this.canBuy, required this.dark, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canBuy ? onBuy : null,
      child: Container(
        width: 78,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: canBuy ? PremiumColors.primary : (dark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.diamond_rounded, size: 14, color: canBuy ? Colors.white : (dark ? Colors.white24 : Colors.black26)),
            const SizedBox(width: 4),
            Text(
              '$cost',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: canBuy ? Colors.white : (dark ? Colors.white24 : Colors.black26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
