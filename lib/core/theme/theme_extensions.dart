import 'package:flutter/material.dart';

class ChestColors extends ThemeExtension<ChestColors> {
  final Color bronze;
  final Color silver;
  final Color gold;
  final Color legendary;

  const ChestColors({
    required this.bronze,
    required this.silver,
    required this.gold,
    required this.legendary,
  });

  @override
  ChestColors copyWith({Color? bronze, Color? silver, Color? gold, Color? legendary}) {
    return ChestColors(
      bronze: bronze ?? this.bronze,
      silver: silver ?? this.silver,
      gold: gold ?? this.gold,
      legendary: legendary ?? this.legendary,
    );
  }

  @override
  ChestColors lerp(ChestColors other, double t) {
    return ChestColors(
      bronze: Color.lerp(bronze, other.bronze, t)!,
      silver: Color.lerp(silver, other.silver, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      legendary: Color.lerp(legendary, other.legendary, t)!,
    );
  }

  static const light = ChestColors(
    bronze: Color(0xFF8D6E63),
    silver: Color(0xFF9E9E9E),
    gold: Color(0xFFFFB300),
    legendary: Color(0xFFFF8F00),
  );

  static const dark = ChestColors(
    bronze: Color(0xFFA1887F),
    silver: Color(0xFFB0BEC5),
    gold: Color(0xFFFFCA28),
    legendary: Color(0xFFFFB300),
  );
}

class GemColors extends ThemeExtension<GemColors> {
  final Color primary;
  final Color secondary;

  const GemColors({required this.primary, required this.secondary});

  @override
  GemColors copyWith({Color? primary, Color? secondary}) {
    return GemColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  GemColors lerp(GemColors other, double t) {
    return GemColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  static const light = GemColors(
    primary: Color(0xFF4FC3F7),
    secondary: Color(0xFF29B6F6),
  );

  static const dark = GemColors(
    primary: Color(0xFF4FC3F7),
    secondary: Color(0xFF81D4FA),
  );
}

class StreakColors extends ThemeExtension<StreakColors> {
  final Color chispa;
  final Color constante;
  final Color azul;
  final Color cosmica;

  const StreakColors({
    required this.chispa,
    required this.constante,
    required this.azul,
    required this.cosmica,
  });

  @override
  StreakColors copyWith({Color? chispa, Color? constante, Color? azul, Color? cosmica}) {
    return StreakColors(
      chispa: chispa ?? this.chispa,
      constante: constante ?? this.constante,
      azul: azul ?? this.azul,
      cosmica: cosmica ?? this.cosmica,
    );
  }

  @override
  StreakColors lerp(StreakColors other, double t) {
    return StreakColors(
      chispa: Color.lerp(chispa, other.chispa, t)!,
      constante: Color.lerp(constante, other.constante, t)!,
      azul: Color.lerp(azul, other.azul, t)!,
      cosmica: Color.lerp(cosmica, other.cosmica, t)!,
    );
  }

  static const light = StreakColors(
    chispa: Color(0xFFFF6D00),
    constante: Color(0xFFD50000),
    azul: Color(0xFF1565C0),
    cosmica: Color(0xFFAA00FF),
  );

  static const dark = StreakColors(
    chispa: Color(0xFFFFB300),
    constante: Color(0xFFFF1744),
    azul: Color(0xFF448AFF),
    cosmica: Color(0xFFFFD700),
  );
}
