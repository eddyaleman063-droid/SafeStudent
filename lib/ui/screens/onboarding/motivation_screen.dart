// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class MotivationScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const MotivationScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final List<bool> _selections = List.generate(7, (_) => false);
  bool _isPressed = false;

  static const double _progressValue = 0.80;

  static const List<Map<String, dynamic>> _options = [
    {"label": "Carrera profesional", "icon": Icons.work},
    {"label": "Estudios", "icon": Icons.school},
    {"label": "Divertirme", "icon": Icons.celebration},
    {"label": "Ejercitar mi mente", "icon": Icons.psychology},
    {"label": "Conectarme con personas", "icon": Icons.people},
    {"label": "Viajar", "icon": Icons.flight},
    {"label": "Otros", "icon": Icons.more_horiz},
  ];

  int get _selectedCount => _selections.where((s) => s).length;

  String get _dialogText {
    final count = _selectedCount;
    if (count == 0) {
      return "¿Por qué te interesa dominar el entorno digital?";
    }
    if (count > 1) {
      return "¡Excelentes motivos para aprender!";
    }
    final idx = _selections.indexOf(true);
    switch (idx) {
      case 0:
        return "¡Un mundo de oportunidades se abrirá para ti!";
      case 1:
        return "¡Superarás esos exámenes y proyectos sin problemas!";
      case 2:
        return "¡Me encanta! La diversión es mi especialidad.";
      case 3:
        return "Es una sabia decisión.";
      case 4:
        return "¡Vamos a prepararte para conversar!";
      case 5:
        return "¡No hay nada mejor que viajar con tus dispositivos 100% blindados!";
      case 6:
        return "¡Entendido! Cuéntame más en el camino.";
      default:
        return "¿Por qué te interesa dominar el entorno digital?";
    }
  }

  String get _mascotAsset {
    final count = _selectedCount;
    if (count == 0) {
      return 'assets/mascot/emotions/sage_curious.png';
    }
    if (count > 1) {
      return 'assets/mascot/emotions/sage_excited_wave.png';
    }
    final idx = _selections.indexOf(true);
    switch (idx) {
      case 0:
        return 'assets/mascot/emotions/sage_thinking.png';
      case 1:
        return 'assets/mascot/emotions/sage_happy_wings.png';
      case 2:
        return 'assets/mascot/emotions/sage_laughing.png';
      case 3:
        return 'assets/mascot/emotions/sage_thinking.png';
      case 4:
        return 'assets/mascot/emotions/sage_happy_wings.png';
      case 5:
        return 'assets/mascot/emotions/sage_wink.png';
      case 6:
        return 'assets/mascot/emotions/sage_curious.png';
      default:
        return 'assets/mascot/emotions/sage_curious.png';
    }
  }

  void _toggle(int index) {
    setState(() {
      if (index == 6) {
        for (int i = 0; i < 6; i++) {
          _selections[i] = false;
        }
        _selections[6] = !_selections[6];
      } else {
        if (_selections[6]) {
          _selections[6] = false;
        }
        _selections[index] = !_selections[index];
      }
    });
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    HapticFeedback.mediumImpact();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onContinue?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  bool get _canContinue => _selections.contains(true);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: dark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                    ),
                    onPressed: widget.onBack ?? () => Navigator.pop(context),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: dark ? Colors.grey[850] : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressValue,
                        child: Container(
                          decoration: BoxDecoration(
                            color: PremiumColors.primaryAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Mascot row ──
            RepaintBoundary(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      _mascotAsset,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: dark ? const Color(0xFF2A3448) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: dark
                                    ? Colors.white.withValues(alpha: 0.10)
                                    : Colors.grey.withValues(alpha: 0.30),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                _dialogText,
                                key: ValueKey(_dialogText),
                                style: TextStyle(
                                  color: dark ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Transform.translate(
                              offset: const Offset(-6, 0),
                              child: Transform.rotate(
                                angle: math.pi / 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: dark ? const Color(0xFF2A3448) : Colors.white,
                                    border: Border.all(
                                      color: dark
                                          ? Colors.white.withValues(alpha: 0.10)
                                          : Colors.grey.withValues(alpha: 0.30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Scrollable options ──
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selections[index];
                  final opt = _options[index];
                  return GestureDetector(
                    onTap: () => _toggle(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PremiumColors.primaryAccent
                                .withValues(alpha: 0.08)
                            : (dark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? PremiumColors.primaryAccent
                              : (dark
                                  ? Colors.white.withValues(alpha: 0.10)
                                  : Colors.grey.withValues(alpha: 0.30)),
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            opt["icon"] as IconData,
                            color: isSelected
                                ? PremiumColors.primaryAccent
                                : (dark ? Colors.white.withValues(alpha: 0.50) : Colors.black54),
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              opt["label"] as String,
                              style: TextStyle(
                                color: dark ? Colors.white.withValues(alpha: 0.90) : Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? PremiumColors.primaryAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? PremiumColors.primaryAccent
                                    : (dark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30)),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: dark ? Colors.white : Colors.black87,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Bottom button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
              child: GestureDetector(
                onTapDown: _canContinue ? _onTapDown : null,
                onTapUp: _canContinue ? _onTapUp : null,
                onTapCancel: _canContinue ? _onTapCancel : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  transform: _isPressed
                      ? Matrix4.translationValues(0, 4, 0)
                      : Matrix4.identity(),
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _canContinue
                        ? PremiumColors.primaryAccent
                        : (dark ? Colors.grey[850] : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isPressed || !_canContinue
                        ? []
                        : [
                            BoxShadow(
                              color: PremiumColors.primaryDark,
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      'CONTINUAR',
                      style: TextStyle(
                        color: _canContinue
                            ? (dark ? Colors.white : Colors.black87)
                            : (dark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30)),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
