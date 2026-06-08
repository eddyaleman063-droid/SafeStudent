import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/sage_emotion_service.dart';
import '../../../services/motivational_quotes_service.dart';
import 'sage_emotion_widget.dart';

class PremiumLoader extends StatefulWidget {
  final Widget child;
  final bool loading;
  final String? message;
  const PremiumLoader({
    super.key,
    required this.child,
    this.loading = false,
    this.message,
  });

  @override
  State<PremiumLoader> createState() => _PremiumLoaderState();
}

class _PremiumLoaderState extends State<PremiumLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  String _currentQuote = '';
  Timer? _quoteTimer;

  @override
  void initState() {
    super.initState();
    _currentQuote = MotivationalQuotesService.instance.random();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _pulseCtrl.repeat(reverse: true);
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    if (widget.loading) _fadeCtrl.forward();
    _quoteTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() => _currentQuote = MotivationalQuotesService.instance.random());
    });
  }

  @override
  void didUpdateWidget(PremiumLoader old) {
    super.didUpdateWidget(old);
    if (widget.loading != old.loading) {
      if (widget.loading) {
        _fadeCtrl.forward();
      } else {
        _fadeCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        widget.child,
        if (widget.loading)
          FadeTransition(
            opacity: _fadeCtrl,
            child: Container(
              color: (dark ? const Color(0xFF0A0E1A) : Colors.white).withValues(alpha: 0.92),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, child) => Transform.scale(
                        scale: 0.85 + 0.15 * _pulseCtrl.value,
                        child: child,
                      ),
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dark ? PremiumColors.darkCard : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: PremiumColors.primary.withValues(
                                alpha: 0.1 + 0.15 * (_pulseCtrl.value),
                              ),
                              blurRadius: 20 + 15 * (_pulseCtrl.value),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const SageEmotionWidget(emotion: SageEmotion.thinking, size: 76, animated: false),
                      ),
                    ),
                    if (widget.message != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        widget.message!,
                        style: AppTextStyle.subtitle.copyWith(
                          color: dark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 260,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          _currentQuote,
                          key: ValueKey(_currentQuote),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.caption.copyWith(
                            color: dark ? Colors.white38 : Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
