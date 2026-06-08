import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sagen/l10n/app_localizations.dart';
import '../gem_painter.dart';

class GemRainAnimation extends StatefulWidget {
  final int gemCount;
  final int totalGems;
  final double height;
  final Color gemColor;
  final VoidCallback? onComplete;

  const GemRainAnimation({
    super.key,
    this.gemCount = 15,
    required this.totalGems,
    this.height = 200,
    this.gemColor = const Color(0xFF4FC3F7),
    this.onComplete,
  });

  @override
  State<GemRainAnimation> createState() => _GemRainAnimationState();
}

class _GemRainAnimationState extends State<GemRainAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rainCtrl;
  late AnimationController _sinkCtrl;
  late List<_GemParticle> _particles;
  bool _showCount = false;
  bool _sinking = false;

  static const _gemSize = 16.0;

  @override
  void initState() {
    super.initState();
    _rainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _sinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _initParticles();
    _rainCtrl.addStatusListener(_onRainStatus);
    _sinkCtrl.addListener(_onSinkTick);
    _rainCtrl.forward();
  }

  void _initParticles() {
    final rng = Random(42);
    final count = min(widget.gemCount, widget.totalGems);
    _particles = List.generate(count, (i) {
      final progress = i / max(count - 1, 1);
      return _GemParticle(
        startX: 0.12 + rng.nextDouble() * 0.76,
        startDelay: progress * 0.3,
        fallDuration: 0.5 + rng.nextDouble() * 0.3,
        rotation: rng.nextDouble() * pi * 2,
        rotationSpeed: 2.0 + rng.nextDouble() * 3.0,
        drift: -0.03 + rng.nextDouble() * 0.06,
        endY: 0.55 + rng.nextDouble() * 0.35,
        scale: 0.7 + rng.nextDouble() * 0.3,
      );
    });
  }

  void _onRainStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _showCount = true);
      widget.onComplete?.call();
      if (widget.totalGems > 20 && mounted) {
        _sinkCtrl.forward();
      }
    }
  }

  void _onSinkTick() {
    if (mounted) setState(() => _sinking = _sinkCtrl.isAnimating);
  }

  @override
  void dispose() {
    _rainCtrl.removeStatusListener(_onRainStatus);
    _sinkCtrl.removeListener(_onSinkTick);
    _rainCtrl.dispose();
    _sinkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ground crack (only when sinking)
              if (_sinking)
                Positioned.fill(
                  child: CustomPaint(
                    painter: GroundCrackPainter(sinkT: _sinkCtrl.value),
                  ),
                ),

              // particles
              ..._particles.map((p) => _buildParticle(p, width)),

              // count badge
              if (_showCount)
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                        parent: _rainCtrl,
                        curve: const Interval(0.85, 1.0, curve: Curves.easeOut)),
                    child: SlideTransition(
                      position: Tween<Offset>(
                          begin: const Offset(0, 0.3), end: Offset.zero)
                          .animate(CurvedAnimation(
                          parent: _rainCtrl,
                          curve: const Interval(0.85, 1.0, curve: Curves.easeOutCubic))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFB300)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.diamond_rounded,
                                    size: 18,
                                    color: Colors.white.withValues(alpha: 0.9)),
                                const SizedBox(width: 6),
                                Text(
                                  '+${widget.totalGems}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.profileGems,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParticle(_GemParticle p, double width) {
    final delayInterval = Interval(p.startDelay,
        min(p.startDelay + p.fallDuration, 1.0),
        curve: Curves.easeInCubic);

    return AnimatedBuilder(
      animation: _rainCtrl,
      builder: (context, _) {
        final t = delayInterval.transform(_rainCtrl.value);
        if (t <= 0) return const SizedBox.shrink();

        final baseY =
            -_gemSize + (widget.height * p.endY + _gemSize) * t;
        final drift = sin(t * pi) * p.drift * width;
        final rotation = p.rotation + t * p.rotationSpeed;
        final opacity = t < 1
            ? 1.0
            : (1.0 - (t - 0.95) / 0.05).clamp(0.0, 1.0);
        final s = p.scale *
            (t < 1 ? 1.0 : max(0.3, 1.0 - (t - 0.95) * 5));

        // sink offset: settled gems shift down when ground cracks
        final st = _sinkCtrl.value;
        final sinkOff =
            _sinking ? st * widget.height * (0.06 + p.endY * 0.04) : 0.0;
        final sinkFade =
            _sinking ? (1.0 - st * 0.35).clamp(0.0, 1.0) : 1.0;

        return Positioned(
          left: width * p.startX + drift - (_gemSize * s / 2),
          top: baseY + sinkOff - (_gemSize * s / 2),
          child: Opacity(
            opacity: opacity * sinkFade,
            child: Transform.rotate(
              angle: rotation,
              child: GemShape(
                  size: _gemSize * s,
                  color: widget.gemColor,
                  shine: 0.8),
            ),
          ),
        );
      },
    );
  }
}

class GroundCrackPainter extends CustomPainter {
  final double sinkT;

  GroundCrackPainter({required this.sinkT});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bot = h - 2.0;
    final cx = w / 2;

    // dark crack fill — opens from center outward
    final crackH = 3 + sinkT * 20;
    final spreadLerp = 0.3 + sinkT * 0.7;
    final crackLeft = cx - cx * spreadLerp;
    final crackRight = cx + (w - cx) * spreadLerp;

    // inner glow (magma)
    if (sinkT > 0.15) {
      final glowAlpha = (sinkT - 0.15) / 0.85 * 0.35;
      final glowPaint = Paint()
        ..isAntiAlias = true
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFF6D00).withValues(alpha: glowAlpha),
            const Color(0xFFFF3D00).withValues(alpha: glowAlpha * 0.5),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
            center: Offset(cx, bot), radius: crackH * 1.5));
      canvas.drawCircle(Offset(cx, bot), crackH * 1.5, glowPaint);
    }

    // crack fill
    final crackPaint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFF1A0A00).withValues(alpha: 0.5 + sinkT * 0.35);
    canvas.drawRect(
        Rect.fromLTRB(crackLeft, bot - crackH, crackRight, bot + 4),
        crackPaint);

    // main jagged crack line — propagates from center
    final linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 + sinkT * 2.0
      ..color = const Color(0xFF4A3020).withValues(alpha: 0.4 + sinkT * 0.5);

    final rng = Random(7);

    // right side from center
    final rightPath = Path()..moveTo(cx, bot);
    var rx = cx;
    while (rx < crackRight) {
      rx += 6 + rng.nextDouble() * 14;
      final yOff = sinkT * rng.nextDouble() * 12;
      rightPath.lineTo(rx.clamp(0, w), bot - 2 - yOff);
    }
    rightPath.lineTo(crackRight, bot);
    canvas.drawPath(rightPath, linePaint);

    // left side from center
    final leftPath = Path()..moveTo(cx, bot);
    var lx = cx;
    while (lx > crackLeft) {
      lx -= 6 + rng.nextDouble() * 14;
      final yOff = sinkT * rng.nextDouble() * 12;
      leftPath.lineTo(lx.clamp(0, w), bot - 2 - yOff);
    }
    leftPath.lineTo(crackLeft, bot);
    canvas.drawPath(leftPath, linePaint);

    // secondary branches
    final secondaryPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 + sinkT * 0.8
      ..color = const Color(0xFF5A4030).withValues(alpha: sinkT * 0.4);

    final rng2 = Random(13);
    final branchCount = 3 + (sinkT * 5).round();
    for (var i = 0; i < branchCount; i++) {
      final side = rng2.nextBool() ? 1 : -1;
      final sx = cx + side * rng2.nextDouble() * w * 0.4;
      final sy = bot - 2 - rng2.nextDouble() * 8;
      final branch = Path()
        ..moveTo(sx, sy)
        ..lineTo(sx + side * (4 + rng2.nextDouble() * 16),
            sy + 4 + rng2.nextDouble() * 12);
      canvas.drawPath(branch, secondaryPaint);
    }

    // depth shadow below crack
    if (sinkT > 0.2) {
      final depthPaint = Paint()
        ..isAntiAlias = true
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.0),
            Colors.black.withValues(alpha: sinkT * 0.25),
          ],
        ).createShader(
            Rect.fromLTWH(crackLeft, bot - crackH, crackRight - crackLeft, crackH + 4));
      canvas.drawRect(
          Rect.fromLTRB(crackLeft, bot - crackH, crackRight, bot + 4),
          depthPaint);
    }

    // debris
    if (sinkT > 0.1) {
      final debrisPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
      final drng = Random(19);
      for (var i = 0; i < (sinkT * 10).round(); i++) {
        final side = drng.nextBool() ? 1 : -1;
        final dx = cx + side * drng.nextDouble() * w * 0.35;
        final dy = bot - 3 - drng.nextDouble() * sinkT * 24;
        final ds = 1.0 + drng.nextDouble() * 2.5;
        debrisPaint.color = const Color(0xFF6A5040)
            .withValues(alpha: sinkT * (0.2 + drng.nextDouble() * 0.3));
        canvas.drawCircle(Offset(dx, dy), ds, debrisPaint);
      }
    }
  }

  @override
  bool shouldRepaint(GroundCrackPainter old) => old.sinkT != sinkT;
}

class _GemParticle {
  final double startX;
  final double startDelay;
  final double fallDuration;
  final double rotation;
  final double rotationSpeed;
  final double drift;
  final double endY;
  final double scale;

  const _GemParticle({
    required this.startX,
    required this.startDelay,
    required this.fallDuration,
    required this.rotation,
    required this.rotationSpeed,
    required this.drift,
    required this.endY,
    required this.scale,
  });
}
