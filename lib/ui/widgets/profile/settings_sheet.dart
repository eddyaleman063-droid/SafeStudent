import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/widgets/profile/theme_selector.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.xxl),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        color: dark ? PremiumColors.darkSurface : Colors.white,
        boxShadow: AppShadows.card(color: dark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.xl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              color: dark ? Colors.white12 : Colors.black12,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 18, color: PremiumColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.settingsTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ThemeSelector(dark: dark),
          const SizedBox(height: AppSpacing.xl),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
