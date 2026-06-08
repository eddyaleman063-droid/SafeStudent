import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/hardware_tier_provider.dart';

class AmbientBackground extends ConsumerStatefulWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  ConsumerState<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends ConsumerState<AmbientBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;
  Animation<double>? _fadeAnim;

  static const _darkA = Color(0xFF0A0E1A);
  static const _darkB = Color(0xFF0D1B2A);
  static const _lightA = Color(0xFFF0F4FF);
  static const _lightB = Color(0xFFE8F0FE);

  @override
  void initState() {
    super.initState();
    final reduce = ref.read(reduceAnimationsProvider);
    if (!reduce) {
      _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8));
      _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl!, curve: Curves.easeInOutSine),
      );
      try { _ctrl!.repeat(reverse: true); } catch (_) {}
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? const [_darkA, _darkB] : const [_lightA, _lightB];

    if (_ctrl == null || !_ctrl!.isAnimating) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: widget.child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnim!,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? const [_darkB, Colors.transparent]
                  : const [_lightB, Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
