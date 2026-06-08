import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedFire extends StatefulWidget {
  final double intensity;
  final Color primaryColor;
  final Color secondaryColor;

  const AnimatedFire({
    super.key,
    this.intensity = 1.0,
    this.primaryColor = const Color(0xFFFF6D00),
    this.secondaryColor = const Color(0xFFFFB300),
  });

  @override
  State<AnimatedFire> createState() => _AnimatedFireState();
}

class _AnimatedFireState extends State<AnimatedFire>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random(42);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => CustomPaint(
        painter: _FirePainter(
          time: _ctrl.value,
          intensity: widget.intensity,
          primary: widget.primaryColor,
          secondary: widget.secondaryColor,
          rng: _rng,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FirePainter extends CustomPainter {
  final double time;
  final double intensity;
  final Color primary;
  final Color secondary;
  final Random rng;

  _FirePainter({
    required this.time,
    required this.intensity,
    required this.primary,
    required this.secondary,
    required this.rng,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height;

    _drawBaseGlow(canvas, cx, cy, size);
    _drawFlameBody(canvas, cx, cy, size);
    _drawEmbers(canvas, cx, cy, size);
  }

  void _drawBaseGlow(Canvas canvas, double cx, double cy, Size size) {
    final pulse = 0.85 + 0.15 * sin(time * 2.3);
    final glowRadius = size.width * 0.55 * pulse * intensity;

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          primary.withValues(alpha: 0.25 * intensity),
          secondary.withValues(alpha: 0.10 * intensity),
          primary.withValues(alpha: 0.04 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(
        Rect.fromCircle(center: Offset(cx, cy * 0.75), radius: glowRadius),
      );

    canvas.drawCircle(Offset(cx, cy * 0.75), glowRadius, glow);
  }

  void _drawFlameBody(Canvas canvas, double cx, double cy, Size size) {
    for (int i = 0; i < 6; i++) {
      final phase = i * 0.4 + time;
      final flicker = 0.75 + 0.25 * sin(phase * 4.7 + i * 1.3);
      final sway = 0.06 * sin(time * 2.1 + i * 1.7);
      final rise = 0.05 * sin(time * 3.3 + i * 2.1);

      final fy = cy * (0.25 + i * 0.09) - rise * cy * 0.1;
      final fx = cx + sway * size.width;
      final flameRadius = size.width * (0.12 + i * 0.025) * flicker * intensity;

      final flame = Paint()
        ..shader = RadialGradient(
          colors: [
            secondary.withValues(alpha: 0.35 * flicker * intensity),
            primary.withValues(alpha: 0.20 * flicker * intensity),
            primary.withValues(alpha: 0.05 * flicker * intensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ).createShader(
          Rect.fromCircle(center: Offset(fx, fy), radius: flameRadius),
        );

      canvas.drawCircle(Offset(fx, fy), flameRadius, flame);
    }
  }

  void _drawEmbers(Canvas canvas, double cx, double cy, Size size) {
    for (int i = 0; i < 24; i++) {
      final seed = i * 0.73;
      final t = (time * 0.6 + seed) % 1.0;
      final py = cy * (0.85 - t * 0.85);
      final drift = sin(t * 6.28 * 3 + seed * 5.0) * size.width * 0.18;
      final px = cx + drift;

      final opacity = (1.0 - t) * (t < 0.15 ? t / 0.15 : 1.0) * 0.7 * intensity;
      final eSize = (1.5 + 3.0 * (1.0 - t)) * intensity;

      final ember = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: opacity * 0.9),
            secondary.withValues(alpha: opacity * 0.5),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: Offset(px, py), radius: eSize),
        );

      canvas.drawCircle(Offset(px, py), eSize, ember);
    }
  }

  @override
  bool shouldRepaint(_FirePainter old) => old.time != time;
}
