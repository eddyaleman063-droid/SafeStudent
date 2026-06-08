import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/sage_emotion_service.dart';
import '../../../services/streak_visibility_service.dart';
import '../../widgets/common/sage_emotion_widget.dart';
import '../../widgets/streak/flame_animation_widget.dart';

class HabitTransitionScreen extends StatefulWidget {
  const HabitTransitionScreen({super.key});

  @override
  State<HabitTransitionScreen> createState() => _HabitTransitionScreenState();
}

class _HabitTransitionScreenState extends State<HabitTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _sageFade;
  late final Animation<Offset> _sageSlide;
  late final Animation<double> _bubbleFade;
  late final Animation<double> _bubbleScale;

  late final String _message;

  static const _messages = [
    '¡Gran trabajo! Ahora, vamos a blindar tu disciplina diaria.',
    'Primer paso completado. Construyamos el hábito que te llevará a la meta.',
    'Excelente rendimiento. El secreto ahora es la constancia.',
    '¡Bien hecho! Ahora configuremos tu ritmo de progreso diario.',
    'Un inicio perfecto. Aseguremos tu éxito creando un hábito inquebrantable.',
  ];

  @override
  void initState() {
    super.initState();
    _message = _messages[Random().nextInt(_messages.length)];

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _sageFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    );
    _sageSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));

    _bubbleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
    );
    _bubbleScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 1.0, curve: Curves.elasticOut),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleContinue() {
    HapticFeedback.lightImpact();
    _pushNext();
  }

  Future<void> _pushNext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final visibility = StreakVisibilityService(prefs);
      if (!mounted) return;

      if (visibility.shouldShow()) {
        context.pushNamed('streak');
      } else {
        context.goNamed('main');
      }
    } catch (_) {
      if (!mounted) return;
      context.goNamed('main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? PremiumColors.darkBg : PremiumColors.lightBg;
    final bubbleColor = dark ? PremiumColors.darkSurface : Colors.white;
    final textColor = dark ? PremiumColors.textLight : PremiumColors.textDark;

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
                  SizedBox(height: h * 0.08),
                  SizedBox(
                    height: h * 0.28,
                    child: Center(
                      child: FadeTransition(
                        opacity: _bubbleFade,
                        child: ScaleTransition(
                          scale: _bubbleScale,
                          alignment: Alignment.bottomCenter,
                          child: _SpeechBubble(
                            message: _message,
                            color: bubbleColor,
                            textColor: textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.38,
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: FlameAnimationWidget(phase: null),
                          ),
                        ),
                        Center(
                          child: FadeTransition(
                            opacity: _sageFade,
                            child: SlideTransition(
                              position: _sageSlide,
                              child: SageEmotionWidget(
                                emotion: SageEmotion.excitedWave,
                                size: (h * 0.28).clamp(100, 200),
                                animated: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _ContinueButton(onPressed: _handleContinue),
                  SizedBox(height: h * 0.06),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  final String message;
  final Color color;
  final Color textColor;

  const _SpeechBubble({
    required this.message,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 32,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.5,
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
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 32,
                        offset: const Offset(0, 10),
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
            child: Container(height: 8, color: color),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppGradients.sage(),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: PremiumColors.xpColor.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'CONTINUAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
