import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/theme_constants.dart';

class SagenTouchResponse extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  const SagenTouchResponse({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<SagenTouchResponse> createState() => _SagenTouchResponseState();
}

class _SagenTouchResponseState extends State<SagenTouchResponse> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled
          ? (_) {
              HapticFeedback.lightImpact();
              setState(() => _isPressed = true);
            }
          : null,
      onTapUp: widget.enabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.enabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppMotion.fast,
        curve: AppEasing.standard,
        child: widget.child,
      ),
    );
  }
}
