import 'package:flutter/material.dart';
import 'theme_constants.dart';
import 'theme_extensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: PremiumColors.primary,
        scaffoldBackgroundColor: PremiumColors.lightBg,
        cardColor: Colors.white,
        dividerColor: Colors.black.withValues(alpha: 0.08),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: PremiumColors.textDark,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: PremiumColors.primary,
          unselectedItemColor: Colors.black38,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF0F4FF),
          selectedColor: PremiumColors.primary.withValues(alpha: 0.15),
          labelStyle: const TextStyle(color: PremiumColors.textDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        extensions: const [
          ChestColors.light,
          GemColors.light,
          StreakColors.light,
        ],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: PremiumColors.primary,
        scaffoldBackgroundColor: PremiumColors.darkBg,
        cardColor: PremiumColors.darkCard,
        dividerColor: Colors.white.withValues(alpha: 0.08),
        appBarTheme: const AppBarTheme(
          backgroundColor: PremiumColors.darkSurface,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: PremiumColors.darkSurface,
          selectedItemColor: PremiumColors.primary,
          unselectedItemColor: Colors.white38,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: PremiumColors.darkCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: PremiumColors.darkSurface,
          selectedColor: PremiumColors.primary.withValues(alpha: 0.15),
          labelStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        extensions: const [
          ChestColors.dark,
          GemColors.dark,
          StreakColors.dark,
        ],
      );
}
