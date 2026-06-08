import 'package:flutter/material.dart';

class GemPainter extends CustomPainter {
  final Color color;
  final double shine;

  GemPainter({this.color = const Color(0xFF4FC3F7), this.shine = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s / 2);
    final sc = s / 2;

    // facet polygon points (normalized -1..1, scaled by sc)
    final top = Offset(c.dx, c.dy - 0.50 * sc);
    final topR = Offset(c.dx + 0.28 * sc, c.dy - 0.18 * sc);
    final topL = Offset(c.dx - 0.28 * sc, c.dy - 0.18 * sc);
    final midR = Offset(c.dx + 0.48 * sc, c.dy + 0.10 * sc);
    final midL = Offset(c.dx - 0.48 * sc, c.dy + 0.10 * sc);
    final botR = Offset(c.dx + 0.28 * sc, c.dy + 0.42 * sc);
    final botL = Offset(c.dx - 0.28 * sc, c.dy + 0.42 * sc);
    final bot = Offset(c.dx, c.dy + 0.55 * sc);
    final ctr = Offset(c.dx, c.dy + 0.02 * sc);

    final lightColor = color.withValues(alpha: 0.85);
    final darkColor = color.withValues(alpha: 0.40);

    // ── outer glow ──
    final glow = Paint()..isAntiAlias = true;
    glow.shader = RadialGradient(
      colors: [
        color.withValues(alpha: 0.12 * shine),
        color.withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: c, radius: sc * 0.55));
    canvas.drawCircle(c, sc * 0.55, glow);

    // ── gem outline ──
    final outline = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(topR.dx, topR.dy)
      ..lineTo(midR.dx, midR.dy)
      ..lineTo(botR.dx, botR.dy)
      ..lineTo(bot.dx, bot.dy)
      ..lineTo(botL.dx, botL.dy)
      ..lineTo(midL.dx, midL.dy)
      ..lineTo(topL.dx, topL.dy)
      ..close();

    final fill = Paint()..isAntiAlias = true;
    fill.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [lightColor, color, darkColor],
    ).createShader(outline.getBounds());
    canvas.drawPath(outline, fill);

    // ── facets ──
    _drawFacet(canvas, [top, topR, ctr, topL], 1.0);
    _drawFacet(canvas, [topR, midR, ctr], 0.85);
    _drawFacet(canvas, [topL, ctr, midL], 0.75);
    _drawFacet(canvas, [midR, botR, ctr], 0.60);
    _drawFacet(canvas, [midL, ctr, botL], 0.55);
    _drawFacet(canvas, [botR, bot, ctr], 0.45);
    _drawFacet(canvas, [botL, ctr, bot], 0.40);

    // ── shine highlight ──
    if (shine > 0) {
      final hlY = c.dy - 0.28 * sc;
      final hlPath = Path()
        ..moveTo(c.dx - 0.06 * sc, hlY)
        ..lineTo(c.dx + 0.06 * sc, hlY)
        ..lineTo(c.dx + 0.14 * sc, hlY + 0.10 * sc)
        ..lineTo(c.dx - 0.14 * sc, hlY + 0.10 * sc)
        ..close();
      fill.shader = null;
      fill.color = Colors.white.withValues(alpha: 0.50 * shine);
      canvas.drawPath(hlPath, fill);

      // small bright spot
      fill.color = Colors.white.withValues(alpha: 0.70 * shine);
      canvas.drawCircle(Offset(c.dx, c.dy - 0.22 * sc), sc * 0.03, fill);
    }

    // ── edge stroke ──
    final stroke = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.15);
    canvas.drawPath(outline, stroke);
  }

  void _drawFacet(Canvas canvas, List<Offset> pts, double brightness) {
    if (pts.length < 3) return;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    path.close();

    final p = Paint()
      ..isAntiAlias = true
      ..shader = null;

    if (brightness > 0.7) {
      p.color = Colors.white.withValues(alpha: (brightness - 0.7) * 0.35);
      canvas.drawPath(path, p);
    } else {
      p.color = Colors.black.withValues(alpha: (1.0 - brightness) * 0.20);
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(GemPainter old) => old.color != color || old.shine != shine;
}

class GemShape extends StatelessWidget {
  final double size;
  final Color color;
  final double shine;

  const GemShape({
    super.key,
    this.size = 24,
    this.color = const Color(0xFF4FC3F7),
    this.shine = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size * 1.1),
        painter: GemPainter(color: color, shine: shine),
      ),
    );
  }
}
