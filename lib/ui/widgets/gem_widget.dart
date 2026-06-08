import 'package:flutter/material.dart';
import 'gem_painter.dart';

class GemWidget extends StatefulWidget {
  final double size;
  final bool animate;
  final int? value;
  final Color color;

  const GemWidget({
    super.key,
    this.size = 24,
    this.animate = true,
    this.value,
    this.color = const Color(0xFF4FC3F7),
  });

  @override
  State<GemWidget> createState() => _GemWidgetState();
}

class _GemWidgetState extends State<GemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pop;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _pop = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.animate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _play());
    }
  }

  @override
  void didUpdateWidget(GemWidget old) {
    super.didUpdateWidget(old);
    if (widget.animate && widget.value != null && widget.value != old.value) {
      _play();
    }
    if (!old.animate && widget.animate) _play();
  }

  void _play() {
    _ctrl.reset();
    _ctrl.forward().then((_) {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget gem = GemShape(size: widget.size, color: widget.color);

    if (widget.animate) {
      gem = AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _ctrl.isAnimating ? _pop.value : 1.0,
            child: child,
          );
        },
        child: gem,
      );
    }

    return RepaintBoundary(child: gem);
  }
}
