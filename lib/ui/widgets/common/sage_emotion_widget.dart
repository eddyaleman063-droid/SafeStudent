import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/sage_emotion_service.dart';

class SageEmotionWidget extends StatelessWidget {
  final SageEmotion emotion;
  final double size;
  final String? semanticLabel;
  final bool animated;

  const SageEmotionWidget({
    super.key,
    required this.emotion,
    this.size = 90,
    this.semanticLabel,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = size.clamp(40.0, 200.0);

    return RepaintBoundary(
      child: Semantics(
        label: semanticLabel ?? emotion.name,
        child: animated
            ? _LiveSageImage(emotion: emotion, size: s)
            : _StaticSageImage(emotion: emotion, size: s),
      ),
    );
  }
}

class _StaticSageImage extends StatelessWidget {
  final SageEmotion emotion;
  final double size;
  const _StaticSageImage({required this.emotion, required this.size});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final decodeSize = (size * dpr).round().clamp(0, 600);
    return Image.asset(
      emotion.assetPath,
      width: size,
      height: size,
      cacheWidth: decodeSize,
      cacheHeight: decodeSize,
      gaplessPlayback: true,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
      isAntiAlias: true,
    );
  }
}

class _LiveSageImage extends StatefulWidget {
  final SageEmotion emotion;
  final double size;
  const _LiveSageImage({required this.emotion, required this.size});

  @override
  State<_LiveSageImage> createState() => _LiveSageImageState();
}

class _LiveSageImageState extends State<_LiveSageImage>
    with TickerProviderStateMixin {
  static const _transitionMs = 280;

  late AnimationController _transCtrl;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;
  late Animation<double> _scaleUp;

  AnimationController? _breatheCtrl;
  SageEmotion _displayed = SageEmotion.calm;
  SageEmotion _previous = SageEmotion.calm;
  bool _idleBreathe = false;
  int _decodeSize = 0;

  @override
  void initState() {
    super.initState();
    _displayed = widget.emotion;
    _previous = widget.emotion;
    _transCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _transitionMs),
    );
    _fadeIn = CurvedAnimation(parent: _transCtrl, curve: AppEasing.entrance);
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _transCtrl, curve: const Cubic(0.4, 0.0, 0.2, 1.0)),
    );
    _scaleUp = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _transCtrl, curve: AppEasing.entrance),
    );
    _transCtrl.forward();
    _updateBreathing();
  }

  @override
  void didUpdateWidget(_LiveSageImage old) {
    super.didUpdateWidget(old);
    if (old.emotion == widget.emotion) return;
    final service = SageEmotionService.instance;
    if (!service.shouldAnimateEmotionChange(old.emotion, widget.emotion)) {
      _previous = widget.emotion;
      _displayed = widget.emotion;
      _updateBreathing();
      if (mounted) setState(() {});
      return;
    }
    if (service.isSignificantMoodShift(old.emotion, widget.emotion)) {
      HapticFeedback.selectionClick();
    }
    _previous = _displayed;
    _displayed = widget.emotion;
    _transCtrl.reset();
    _transCtrl.forward();
    _updateBreathing();
  }

  void _updateBreathing() {
    final shouldBreathe = SageEmotionService.instance.canIdleBreathe(_displayed);
    if (shouldBreathe == _idleBreathe) return;
    _idleBreathe = shouldBreathe;
    _breatheCtrl?.dispose();
    _breatheCtrl = null;
    if (_idleBreathe) {
      _breatheCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3200),
      );
      _breatheCtrl!.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _transCtrl.dispose();
    _breatheCtrl?.dispose();
    super.dispose();
  }

  double _computeScale() {
    double s = _scaleUp.value;
    if (_idleBreathe && _breatheCtrl != null) {
      s += 0.012 * _breatheCtrl!.value;
    }
    return s;
  }

  Listenable get _listenable {
    if (_breatheCtrl != null) return Listenable.merge([_transCtrl, _breatheCtrl!]);
    return _transCtrl;
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    _decodeSize = (widget.size * dpr).round().clamp(0, 600);

    return AnimatedBuilder(
      animation: _listenable,
      builder: (context, child) {
        final isAnimating = _transCtrl.isAnimating || _transCtrl.value < 1.0;
        final sameEmotion = _previous == _displayed;

        return Transform.scale(
          scale: _computeScale(),
          child: Stack(
            children: [
              if (!sameEmotion && isAnimating)
                Opacity(
                  opacity: _fadeOut.value,
                  child: _buildImage(_previous),
                ),
              Opacity(
                opacity: isAnimating ? _fadeIn.value : 1.0,
                child: _buildImage(_displayed),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImage(SageEmotion emotion) {
    return Image.asset(
      emotion.assetPath,
      width: widget.size,
      height: widget.size,
      cacheWidth: _decodeSize,
      cacheHeight: _decodeSize,
      gaplessPlayback: true,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
      isAntiAlias: true,
    );
  }
}
