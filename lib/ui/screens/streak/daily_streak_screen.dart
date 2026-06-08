// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../providers/providers.dart';
import '../../../services/sage_emotion_service.dart';
import '../../../services/streak_visibility_service.dart';
import '../../widgets/common/sage_emotion_widget.dart';
import '../../widgets/streak/flame_animation_widget.dart';

class DailyStreakScreen extends ConsumerStatefulWidget {
  const DailyStreakScreen({super.key});

  @override
  ConsumerState<DailyStreakScreen> createState() => _DailyStreakScreenState();
}

class _DailyStreakScreenState extends ConsumerState<DailyStreakScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fireFade;
  late final Animation<double> _fireScale;
  late final AnimationController _resetCtrl;

  late final String _message;

  int _todayIndex = 0;
  List<bool> _weekDays = List.filled(7, false);
  bool _isWeeklyReset = false;
  int _streakDays = 0;
  bool _streakFrozen = false;
  bool _showDefrosting = false;
  bool _circleFilled = false;

  static const _dayLabels = ['Ma', 'Mi', 'J', 'V', 'S', 'D', 'L'];

  static const _messages = [
    '¡Una nueva racha! Practica cada día y ayúdala a crecer.',
    '¡Racha activa! La constancia es tu mejor arma hoy.',
    'Cada día cuenta. Tu compromiso te hace más fuerte.',
    '¡Sigue así! La disciplina de hoy es tu victoria de mañana.',
    'Un día más, un paso más cerca de tu meta.',
  ];

  @override
  void initState() {
    super.initState();
    _message = _messages[Random().nextInt(_messages.length)];

    _todayIndex = (DateTime.now().weekday - 2 + 7) % 7;
    _weekDays[_todayIndex] = true;
    _isWeeklyReset = _todayIndex == 6;

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fireFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _fireScale = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStreakData();
      _entryCtrl.forward();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _circleFilled = true);
        HapticFeedback.mediumImpact();
        if (_isWeeklyReset) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) _resetCtrl.forward();
          });
        }
      });
    });
  }

  void _fetchStreakData() {
    final streak = ref.read(streakProvider);
    _streakDays = streak.currentStreak;
    _streakFrozen = streak.isStreakFrozen;
    final storage = ref.read(storageServiceProvider);
    if (storage.getBool('streak_just_defrosted')) {
      _showDefrosting = true;
      storage.setBool('streak_just_defrosted', false);
    }
    final heatmap = streak.heatmapData;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: _todayIndex));
    for (int i = 0; i < 7; i++) {
      if (i == _todayIndex) continue;
      final date = startOfWeek.add(Duration(days: i));
      final key = date.toIso8601String().substring(0, 10);
      _weekDays[i] = heatmap.containsKey(key) && heatmap[key]! > 0;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _resetCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    StreakVisibilityService(prefs).markShown();
    if (!mounted) return;
    context.goNamed('main');
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? PremiumColors.darkBg : PremiumColors.lightBg;
    final bubbleColor = dark ? PremiumColors.darkSurface : Colors.white;
    final textColor = dark ? PremiumColors.textLight : PremiumColors.textDark;
    const accent = PremiumColors.streakOrange;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;
              return Column(
                children: [
                  SizedBox(height: h * 0.05),
                  SizedBox(
                    height: h * 0.20,
                    child: _buildSpeechBubble(bubbleColor, textColor),
                  ),
                  SizedBox(
                    height: h * 0.38,
                    child: _buildHeroSection(accent),
                  ),
                  SizedBox(
                    height: h * 0.18,
                    child: _buildWeekTimeline(accent, dark),
                  ),
                  const Spacer(),
                  _buildButton(),
                  SizedBox(height: h * 0.04),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechBubble(Color bgColor, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: textColor,
                ),
              ),
            ),
            Positioned(
              bottom: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.rotate(
                  angle: pi / 4,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: bgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(height: 7, color: bgColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Color accent) {
    return FadeTransition(
      opacity: _fireFade,
      child: ScaleTransition(
        scale: _fireScale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FlameAnimationWidget(
                  phase: _showDefrosting
                      ? FlamePhase.defrosting
                      : _streakFrozen
                          ? FlamePhase.frozen
                          : null,
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: SageEmotionWidget(
                  emotion: SageEmotion.excitedWave,
                  size: 130,
                  animated: true,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _streakDays.toDouble()),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) => Text(
                      '${val.toInt()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: accent,
                        height: 1,
                        letterSpacing: -1,
                        shadows: [
                          Shadow(
                            color: accent.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'día de racha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: accent.withValues(alpha: 0.8),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekTimeline(Color accent, bool dark) {
    final grayColor = dark ? const Color(0xFF2A3448) : const Color(0xFFD0D0D0);
    final grayText = dark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.3);

    return AnimatedBuilder(
      animation: Listenable.merge([_resetCtrl]),
      builder: (context, _) {
        final rp = _resetCtrl.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final isToday = i == _todayIndex;
            final isPast = _weekDays[i];

            Color circleColor = grayColor;
            double scale = 1.0;
            bool showCheck = false;

            if (_isWeeklyReset && rp > 0 && rp < 1.0) {
              _weeklyResetState(i, rp, accent, grayColor, isPast,
                  outColor: (c) => circleColor = c,
                  outScale: (s) => scale = s,
                  outCheck: (c) => showCheck = c);
            } else {
              final filled = isToday ? _circleFilled : isPast;
              circleColor = filled ? accent : grayColor;
              scale = isToday && _circleFilled ? 1.0 : (isToday ? 0.5 : 1.0);
              showCheck = filled;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _dayLabels[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _circleFilled && i == _todayIndex ? accent : grayText,
                  ),
                ),
                const SizedBox(height: 6),
                Transform.scale(
                  scale: scale,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                    ),
                    child: showCheck
                        ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void _weeklyResetState(
    int index, double rp, Color accent, Color gray, bool defaultPast, {
    required void Function(Color) outColor,
    required void Function(double) outScale,
    required void Function(bool) outCheck,
  }) {
    const waveEnd = 0.7;
    const fillStart = 0.7;

    if (rp < waveEnd) {
      final waveCenter = (index / 6.0) * waveEnd;
      final dist = (rp - waveCenter).abs();
      const pulseWidth = 0.14;
      if (dist < pulseWidth) {
        final pulse = 1.0 - dist / pulseWidth;
        outScale(1.0 + 0.25 * sin(pulse * pi));
        outColor(Color.lerp(accent, Colors.white, pulse)!);
        outCheck(true);
      } else {
        final shouldBeFilled = defaultPast || (rp > waveCenter);
        outColor(shouldBeFilled ? accent : gray);
        outScale(1.0);
        outCheck(shouldBeFilled);
      }
    } else {
      final fillProgress = (rp - fillStart) / (1.0 - fillStart);
      final threshold = index / 6.0;
      if (threshold <= fillProgress) {
        outColor(gray);
        outScale(1.0);
        outCheck(false);
      } else {
        outColor(accent);
        outScale(1.0);
        outCheck(true);
      }
    }
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: PremiumColors.streakOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department_rounded, size: 20),
            const SizedBox(width: 8),
            const Text(
              'MANTENER MI COMPROMISO',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }
}
