import 'package:flutter/material.dart';

class PremiumColors {
  PremiumColors._();

  static const primary = Color(0xFF1565C0);
  static const primaryDark = Color(0xFF0D47A1);
  static const primaryLight = Color(0xFF1E88E5);
  static const primaryAccent = Color(0xFF42A5F5);

  static const shieldActive = Color(0xFF1565C0);
  static const shieldFrozen = Color(0xFF64B5F6);
  static const shieldAchievement = Color(0xFFFFB300);

  static const gradientActive = [Color(0xFF0D47A1), Color(0xFF1E88E5)];
  static const gradientFrozen = [Color(0xFF64B5F6), Color(0xFFBBDEFB)];
  static const gradientAchievement = [Color(0xFFFF8F00), Color(0xFFFFB300)];
  static const gradientHeader = [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)];
  static const gradientSage = [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF7C3AED)];
  static const gradientSafe = [Color(0xFF1B5E20), Color(0xFF43A047)];
  static const gradientSuspicious = [Color(0xFFBF360C), Color(0xFFFF6D00)];
  static const gradientDangerous = [Color(0xFF7F0000), Color(0xFFE53935)];

  static const gradientShieldBasic = [Color(0xFF1565C0), Color(0xFF1E88E5)];
  static const gradientShieldGlow = [Color(0xFF1E88E5), Color(0xFF64B5F6)];
  static const gradientShieldParticles = [Color(0xFF0D47A1), Color(0xFF42A5F5)];
  static const gradientShieldCrystal = [Color(0xFF1A237E), Color(0xFF7C4DFF)];
  static const gradientShieldLegendary = [Color(0xFFFF6F00), Color(0xFFFFB300)];

  static const darkBg = Color(0xFF0A0E1A);
  static const deepBackground = Color(0xFF1B2433);
  static const darkCard = Color(0xFF1A2035);
  static const darkSurface = Color(0xFF1A1F2E);
  static const lightBg = Color(0xFFF0F4FF);

  static const textDark = Color(0xFF1A1A2E);
  static const textLight = Color(0xFFE2E8F0);

  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFE65100);
  static const error = Color(0xFFB71C1C);
  static const info = Color(0xFF1565C0);

  static const typeStreak = Color(0xFFFF6D00);
  static const typeAnalysis = Color(0xFF1565C0);
  static const typeTip = Color(0xFF7B1FA2);
  static const typeAchievement = Color(0xFFFFB300);
  static const typeSystem = Color(0xFF546E7A);

  static const splashBlue = Color(0xFF4AC2DD);
  static const premiumBlue = primary;
  static const streakOrange = Color(0xFFFF6D00);
  static const premiumIce = Color(0xFF64B5F6);
  static const activeStart = Color(0xFF0D47A1);
  static const activeEnd = Color(0xFF1E88E5);
  static const frozenStart = Color(0xFF64B5F6);
  static const frozenEnd = Color(0xFFBBDEFB);
  static const achievementStart = Color(0xFFFF8F00);
  static const achievementEnd = Color(0xFFFFB300);

  static const xpColor = Color(0xFF7C3AED);
  static const heatmapEmpty = Color(0xFFEAEEF4);
  static const heatmapLight = Color(0xFFC8E6C9);
  static const heatmapMedium = Color(0xFF66BB6A);
  static const heatmapHigh = Color(0xFF2E7D32);
  static const heatmapDark = Color(0xFF1B5E20);
}

// ─── Spacing ───────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();
  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
}

// ─── Border Radius ─────────────────────────────────────────
class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 20;
  static const double round = 24;
  static const double pill = 100;
}

// ─── Animation ────────────────────────────────────────────
class AppMotion {
  AppMotion._();
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration celebration = Duration(milliseconds: 1200);
  static const Duration stagger = Duration(milliseconds: 50);
  static const Duration staggerTotal = Duration(milliseconds: 600);
}

class AppEasing {
  AppEasing._();
  static const Curve entrance = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve standard = Curves.easeInOut;
  static const Curve celebration = Curves.easeOutCubic;
  static const Curve spring = Curves.fastOutSlowIn;
}

class AppGradients {
  AppGradients._();

  static LinearGradient shieldActive() => const LinearGradient(
        colors: PremiumColors.gradientActive,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient shieldAchievement() => const LinearGradient(
        colors: PremiumColors.gradientAchievement,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient shieldFrozen() => const LinearGradient(
        colors: PremiumColors.gradientFrozen,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient sage() => const LinearGradient(
        colors: PremiumColors.gradientSage,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient safe() => const LinearGradient(
        colors: PremiumColors.gradientSafe,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient suspicious() => const LinearGradient(
        colors: PremiumColors.gradientSuspicious,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient dangerous() => const LinearGradient(
        colors: PremiumColors.gradientDangerous,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient primaryHeader() => const LinearGradient(
        colors: PremiumColors.gradientHeader,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient shieldLegendary() => const LinearGradient(
        colors: PremiumColors.gradientShieldLegendary,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient shieldCrystal() => const LinearGradient(
        colors: PremiumColors.gradientShieldCrystal,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient shieldGlow() => const LinearGradient(
        colors: PremiumColors.gradientShieldGlow,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient shieldBasic() => const LinearGradient(
        colors: PremiumColors.gradientShieldBasic,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card({Color? color, double blurRadius = 10}) => [
        BoxShadow(
          color: (color ?? Colors.black).withValues(alpha: 0.08),
          blurRadius: blurRadius,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> glow({
    required Color color,
    double intensity = 0.2,
    double radius = 20,
    double spread = 2,
  }) => [
        BoxShadow(
          color: color.withValues(alpha: intensity),
          blurRadius: radius,
          spreadRadius: spread,
        ),
      ];

  static List<BoxShadow> elevated({Color? color, double intensity = 0.08}) => [
        BoxShadow(
          color: (color ?? Colors.black).withValues(alpha: intensity),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
}

class AppEffects {
  AppEffects._();

  static BoxShadow softGlow(Color color) => BoxShadow(
        color: color.withValues(alpha: 0.15),
        blurRadius: 20,
        spreadRadius: 1,
      );

  static BoxShadow strongGlow(Color color) => BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: 30,
        spreadRadius: 4,
      );
}

class AppDurations {
  AppDurations._();
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration checkIn = Duration(milliseconds: 1500);
}

class AppGlassmorphism {
  AppGlassmorphism._();
  static BoxDecoration input({required bool dark}) => BoxDecoration(
    color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.08),
    ),
  );
}

class AppTextStyle {
  AppTextStyle._();
  static const display = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  static const headline = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const question = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3);
  static const cardTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 14);
  static const bodyBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const subtitle = TextStyle(fontSize: 13);
  static const subtitleBold = TextStyle(fontSize: 13, fontWeight: FontWeight.w600);
  static const caption = TextStyle(fontSize: 12);
  static const label = TextStyle(fontSize: 11, fontWeight: FontWeight.w600);
  static const tiny = TextStyle(fontSize: 10);
}
