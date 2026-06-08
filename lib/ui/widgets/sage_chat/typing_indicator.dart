import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class TypingIndicator extends StatefulWidget {
  final bool dark;
  const TypingIndicator({super.key, required this.dark});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl + 36, 0, AppSpacing.xxl, AppSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) {
              final t = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
              final scale = 0.4 + 0.6 * (t < 0.5 ? t * 2 : (1 - t) * 2);
              return Transform.scale(scale: scale, child: child);
            },
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.dark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
