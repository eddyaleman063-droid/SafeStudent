import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'gem_painter.dart';

class GemPileWidget extends StatefulWidget {
  final int gemCount;
  final double maxSize;
  final double itemSize;
  final Color gemColor;

  const GemPileWidget({
    super.key,
    required this.gemCount,
    this.maxSize = 120,
    this.itemSize = 20,
    this.gemColor = const Color(0xFF4FC3F7),
  });

  @override
  State<GemPileWidget> createState() => _GemPileWidgetState();
}

class _GemPileWidgetState extends State<GemPileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerCtrl;
  late List<_GemSlot> _slots;

  @override
  void initState() {
    super.initState();
    _slots = _generateLayout();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: 300 + widget.gemCount.clamp(0, 30) * 20),
    );
    _staggerCtrl.forward();
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.maxSize,
        height: widget.maxSize * 0.85,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // shadow under pile
            Positioned(
              left: 0,
              right: 0,
              bottom: widget.maxSize * 0.10,
              child: CustomPaint(
                size: Size(widget.maxSize, widget.maxSize * 0.30),
                painter: _PileShadowPainter(
                    gemCount: widget.gemCount, color: widget.gemColor),
              ),
            ),
            // gems with stagger
            ..._slots.asMap().entries.map((e) =>
                _buildGem(e.value, e.key, _slots.length)),
          ],
        ),
      ),
    );
  }

  List<_GemSlot> _generateLayout() {
    final rng = math.Random(widget.gemCount);
    final slots = <_GemSlot>[];
    final half = widget.maxSize / 2;
    final ms = widget.maxSize;
    final isz = widget.itemSize;

    if (widget.gemCount <= 0) return slots;

    if (widget.gemCount == 1) {
      slots.add(_GemSlot(
        dx: half, dy: ms * 0.75, size: isz, rotation: 0, shine: 1.0));
      return slots;
    }

    if (widget.gemCount <= 5) {
      for (var i = 0; i < widget.gemCount; i++) {
        final angle = rng.nextDouble() * math.pi * 2;
        final dist = (widget.gemCount <= 3 ? 0.12 : 0.20) * ms;
        slots.add(_GemSlot(
          dx: half + dist * math.cos(angle),
          dy: ms * 0.70 + dist * 0.4 * math.sin(angle).abs(),
          size: isz * (0.85 + rng.nextDouble() * 0.15),
          rotation: rng.nextDouble() * 0.3,
          shine: 0.7 + rng.nextDouble() * 0.3,
        ));
      }
      return slots;
    }

    final layers = widget.gemCount <= 10 ? 2 : 3;
    final perLayer = (widget.gemCount / layers).ceil();

    for (var layer = 0; layer < layers; layer++) {
      final count = layer == layers - 1
          ? widget.gemCount - (layers - 1) * perLayer
          : perLayer;
      final spread = 0.40 - layer * 0.10;
      final yOff = 0.75 - layer * 0.20;
      final sizeMul = 1.0 - layer * 0.12;

      for (var i = 0; i < count; i++) {
        final angle = rng.nextDouble() * math.pi * 2;
        final dist = spread * ms * math.sqrt(rng.nextDouble());
        slots.add(_GemSlot(
          dx: half + dist * math.cos(angle),
          dy: ms * yOff + dist * 0.3 * math.sin(angle).abs(),
          size: isz * sizeMul * (0.80 + rng.nextDouble() * 0.20),
          rotation: rng.nextDouble() * 0.4,
          shine: 0.6 + rng.nextDouble() * 0.4,
        ));
      }
    }

    return slots;
  }

  Widget _buildGem(_GemSlot slot, int index, int total) {
    final delay = index / math.max(total - 1, 1);
    final interval =
        Interval(delay * 0.6, delay * 0.6 + 0.4, curve: Curves.easeOutBack);

    return AnimatedBuilder(
      animation: _staggerCtrl,
      builder: (context, _) {
        final t = interval.transform(_staggerCtrl.value);
        final fadeIn = t.clamp(0.0, 1.0);
        final scale =
            _staggerCtrl.isCompleted ? 1.0 : (0.3 + 0.7 * fadeIn);
        final bounceY = (1.0 - fadeIn) * 8;

        return Positioned(
          left: slot.dx - slot.size * scale / 2,
          top: slot.dy - slot.size * scale / 2 + bounceY,
          child: Opacity(
            opacity: fadeIn,
            child: Transform.rotate(
              angle: slot.rotation,
              child: GemShape(
                size: slot.size * scale,
                color: widget.gemColor,
                shine: slot.shine * fadeIn,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PileShadowPainter extends CustomPainter {
  final int gemCount;
  final Color color;

  _PileShadowPainter({required this.gemCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h * 0.6;

    final spread = 0.15 + (gemCount / 40).clamp(0.0, 0.40);
    final alpha = (0.08 + (gemCount / 30).clamp(0.0, 0.15)).clamp(0.0, 0.25);

    final p = Paint()
      ..isAntiAlias = true
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: alpha * 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(cx, cy),
        radius: w * spread,
      ));

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: w * spread * 2,
        height: h * 0.4,
      ),
      p,
    );
  }

  @override
  bool shouldRepaint(_PileShadowPainter old) =>
      old.gemCount != gemCount || old.color != color;
}

class _GemSlot {
  final double dx;
  final double dy;
  final double size;
  final double rotation;
  final double shine;

  const _GemSlot({
    required this.dx,
    required this.dy,
    required this.size,
    required this.rotation,
    required this.shine,
  });
}
