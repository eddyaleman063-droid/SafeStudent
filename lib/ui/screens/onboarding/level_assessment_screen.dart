// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';

class LevelAssessmentScreen extends ConsumerStatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const LevelAssessmentScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  ConsumerState<LevelAssessmentScreen> createState() =>
      _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState
    extends ConsumerState<LevelAssessmentScreen> {
  int? _selectedLevelIndex;
  bool _isPressed = false;

  static const _progressValue = 0.65;

  static const _levelLabels = [
    "Cero absoluto (No sé qué es Phishing o un ataque informático)",
    "Sé lo básico (Protejo mis cuentas y reconozco estafas comunes)",
    "Nivel Intermedio (Entiendo de redes, cortafuegos y malware)",
    "Nivel Avanzado (Puedo configurar sistemas seguros y entender exploits)",
    "Experto en Ciberseguridad (Busco vulnerabilidades y blindo sistemas enteros)",
  ];

  void _onTapUp() {
    setState(() => _isPressed = false);
    if (_selectedLevelIndex != null) {
      ref.read(assessmentLevelProvider.notifier).state = _selectedLevelIndex;
      HapticFeedback.lightImpact();
      widget.onContinue?.call();
    }
  }

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
                      'assets/mascot/emotions/sage_thinking.png',
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
                            child: Text(
                              "¿Cuál es tu nivel actual en ciberseguridad?",
                              style: TextStyle(
                                color: dark ? Colors.white : Colors.black87,
                                fontSize: 15,
                                height: 1.4,
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

            const SizedBox(height: AppSpacing.xxl),

            // ── Scrollable options ──
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                itemCount: _levelLabels.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedLevelIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedLevelIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 68,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PremiumColors.primaryAccent.withValues(alpha: 0.08)
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
                          _SignalBars(litCount: index + 1),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _levelLabels[index],
                              style: TextStyle(
                                color: dark ? Colors.white.withValues(alpha: 0.90) : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: PremiumColors.primaryAccent,
                              size: 22,
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
                onTapDown: _selectedLevelIndex != null
                    ? (_) => setState(() => _isPressed = true)
                    : null,
                onTapUp: _selectedLevelIndex != null
                    ? (_) => _onTapUp()
                    : null,
                onTapCancel: _selectedLevelIndex != null
                    ? () => setState(() => _isPressed = false)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  transform: _isPressed
                      ? Matrix4.translationValues(0, 4, 0)
                      : Matrix4.identity(),
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _selectedLevelIndex != null
                        ? PremiumColors.primaryAccent
                        : (dark ? Colors.grey[850] : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isPressed || _selectedLevelIndex == null
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
                        color: _selectedLevelIndex != null
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

// ── Signal bar indicator ──────────────────────────────────

class _SignalBars extends StatelessWidget {
  final int litCount;

  const _SignalBars({required this.litCount});

  static const List<double> _barHeights = [6.0, 10.0, 14.0, 18.0, 22.0];
  static const double _barWidth = 3.5;
  static const double _barSpacing = 2.0;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: _barWidth * 5 + _barSpacing * 4,
      height: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (int i) {
          final bool lit = i < litCount;
          return Container(
            width: _barWidth,
            height: _barHeights[i],
            margin: EdgeInsets.only(right: i < 4 ? _barSpacing : 0),
            decoration: BoxDecoration(
              color: lit
                  ? PremiumColors.primaryAccent
                  : (dark ? Colors.white.withValues(alpha: 0.12) : Colors.black12),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
