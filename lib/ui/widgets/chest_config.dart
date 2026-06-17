import 'dart:ui';

class ChestConfig {
  final Color bodyColor;
  final Color accentColor;
  final Color glowColor;
  final double lidTop;
  final double bodyTop;
  final double bodyBottom;
  final double bodyRadius;
  final int bandCount;
  final double bandWidth;
  final bool hasArch;
  final bool lockGem;
  final double lockSize;
  final Color particleColor;

  const ChestConfig({
    required this.bodyColor,
    required this.accentColor,
    required this.glowColor,
    required this.lidTop,
    required this.bodyTop,
    required this.bodyBottom,
    required this.bodyRadius,
    required this.bandCount,
    required this.bandWidth,
    required this.hasArch,
    required this.lockGem,
    required this.lockSize,
    required this.particleColor,
  });
}
