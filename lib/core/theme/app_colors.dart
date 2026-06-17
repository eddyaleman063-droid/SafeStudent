import 'package:flutter/material.dart';
import 'theme_constants.dart';

extension AppColorsX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get textPrimary => isDark ? Colors.white : PremiumColors.textDark;
  Color get textSecondary => isDark ? Colors.white70 : Colors.black54;
  Color get textTertiary => isDark ? Colors.white38 : Colors.black38;
  Color get textDisabled => isDark ? Colors.white24 : Colors.black26;

  Color get surfaceCard => isDark ? PremiumColors.darkCard : Colors.white;
  Color get surfaceBackground => isDark ? PremiumColors.darkBg : PremiumColors.lightBg;

  Color get subtle => isDark ? Colors.white12 : Colors.black12;
  Color get subtleBorder => isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);

  Color get shimmerBase => isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06);
  Color get shimmerHighlight => isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.12);
}
