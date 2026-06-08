import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/ui/widgets/common/sagen_touch_response.dart';

class SagenRecommendedCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;

  const SagenRecommendedCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.isSelected,
    this.isRecommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).colorScheme.primary;
    final borderColor = isSelected
        ? accentColor
        : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15);
    final bgColor = isSelected
        ? accentColor.withValues(alpha: 0.10)
        : Colors.transparent;
    final titleColor = isSelected
        ? accentColor
        : Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxs,
      ),
      child: SagenTouchResponse(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppEasing.standard,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  isRecommended ? AppSpacing.xxxl : AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: leading,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isRecommended)
            Positioned(
              top: -8,
              right: AppSpacing.lg,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'RECOMENDADO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}
