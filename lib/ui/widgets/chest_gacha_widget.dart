import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/models/chest_evolution.dart';
import 'package:sagen/models/chest_type.dart';
import 'package:sagen/services/experience_service.dart';
import 'chest_widget.dart';

enum _OrbState { idle, success, fail }

class ChestGachaWidget extends StatefulWidget {
  final ChestType initialType;
  final ValueChanged<ChestEvolutionResult> onComplete;

  const ChestGachaWidget({
    super.key,
    required this.initialType,
    required this.onComplete,
  });

  @override
  State<ChestGachaWidget> createState() => _ChestGachaWidgetState();
}

class _ChestGachaWidgetState extends State<ChestGachaWidget>
    with TickerProviderStateMixin {
  late ChestEvolutionResult _result;
  int _currentAttempt = 0;
  bool _isProcessing = false;

  late AnimationController _chestPulse;
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  late ChestType _displayType;
  String _statusKey = '';
  bool _showStatus = false;
  List<_OrbState> _orbStates = [];
  bool _showGlow = false;

  @override
  void initState() {
    super.initState();
    _displayType = widget.initialType;
    _result = ChestEvolutionService.instance.runGacha(widget.initialType);
    _orbStates = List.filled(3, _OrbState.idle);

    _chestPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _glowAnim = CurvedAnimation(parent: _glowCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _chestPulse.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_isProcessing || _currentAttempt >= 3) return;

    setState(() => _isProcessing = true);

    final attempt = _result.attempts[_currentAttempt];
    final upgraded = attempt.upgraded;

    if (upgraded) {
      ExperienceService.instance.chestEvolveHaptic();
    } else {
      ExperienceService.instance.chestFailHaptic();
    }

    _orbStates[_currentAttempt] = upgraded ? _OrbState.success : _OrbState.fail;

    final l = AppLocalizations.of(context)!;
    _statusKey = upgraded
        ? l.chestEvolvedTo(attempt.typeAfter.localizedLabel(l))
        : l.chestNoChange;

    if (upgraded) {
      setState(() {
        _showGlow = true;
        _displayType = attempt.typeAfter;
      });
      _glowCtrl.forward().then((_) {
        if (mounted) setState(() => _showGlow = false);
      });
    }

    _currentAttempt++;
    setState(() => _showStatus = true);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentAttempt >= 3) {
        widget.onComplete(_result);
      } else {
        setState(() {
          _isProcessing = false;
          _showStatus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: _isProcessing ? null : _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChestArea(),
          const SizedBox(height: 8),
          _buildOrbs(),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showStatus
                ? _StatusBadge(key: ValueKey(_statusKey), text: _statusKey)
                : Text(
                    l.chestTapToUpgrade,
                    key: const ValueKey('hint'),
                    style: AppTextStyle.subtitle.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChestArea() {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _chestPulse,
            builder: (_, child) => Transform.scale(
              scale: 1.0 + _chestPulse.value * 0.03,
              child: child,
            ),
            child: ChestWidget(
              key: ValueKey('chest_${_displayType.name}'),
              type: _displayType,
              size: 160,
            ),
          ),
          if (_showGlow)
            FadeTransition(
              opacity: _glowAnim,
              child: IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _displayType.color.withValues(alpha: 0.4),
                        _displayType.color.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrbs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => _OrbWidget(
        index: i,
        state: _orbStates[i],
        isCurrent: i == _currentAttempt && !_isProcessing,
        color: _displayType.color,
        pulseAnim: _chestPulse,
      )),
    );
  }
}

class _OrbWidget extends StatelessWidget {
  final int index;
  final _OrbState state;
  final bool isCurrent;
  final Color color;
  final Animation<double> pulseAnim;

  const _OrbWidget({
    required this.index,
    required this.state,
    required this.isCurrent,
    required this.color,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget orb;
    switch (state) {
      case _OrbState.idle:
        orb = AnimatedBuilder(
          animation: pulseAnim,
          builder: (_, child) {
            final scale = isCurrent ? 1.0 + pulseAnim.value * 0.15 : 1.0;
            final opacity = isCurrent ? 0.8 + pulseAnim.value * 0.2 : 0.4;
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          },
          child: _circle(
            color: isCurrent ? color : cs.onSurface.withValues(alpha: 0.38),
            size: isCurrent ? 36 : 28,
          ),
        );
      case _OrbState.success:
        orb = _circle(
          color: Colors.greenAccent,
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
        );
      case _OrbState.fail:
        orb = _circle(
          color: Colors.grey.shade600,
          child: const Icon(Icons.close_rounded, color: Colors.white38, size: 16),
        );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          orb,
          const SizedBox(height: 4),
          Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 11,
              color: state == _OrbState.idle
                  ? cs.onSurface.withValues(alpha: 0.38)
                  : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle({required Color color, double size = 28, Widget? child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.25),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  const _StatusBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (_, scale, child) => Transform.scale(
        scale: scale,
        child: child,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
