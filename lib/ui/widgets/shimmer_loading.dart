import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _anim = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ?? (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06));
    final highlight = widget.highlightColor ?? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.12));

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                colors: [base, highlight, base],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(_anim.value - 1, 0),
                end: Alignment(_anim.value + 1, 0),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  final int lines;
  final double spacing;
  final double lineHeight;

  const ShimmerBlock({
    super.key,
    this.lines = 3,
    this.spacing = 12,
    this.lineHeight = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i < lines - 1 ? spacing : 0),
          child: ShimmerLoading(
            width: i == lines - 1 ? 0.6 : 0.9,
            height: lineHeight,
          ),
        );
      }),
    );
  }
}
