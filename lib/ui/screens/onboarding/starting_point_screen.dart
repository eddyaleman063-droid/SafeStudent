// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';

class StartingPointScreen extends ConsumerStatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const StartingPointScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  ConsumerState<StartingPointScreen> createState() =>
      _StartingPointScreenState();
}

class _StartingPointScreenState extends ConsumerState<StartingPointScreen> {
  int? _selectedCard;
  bool _isPressed = false;

  static const double _progressValue = 0.98;

  int? get _assessmentLevel => ref.watch(assessmentLevelProvider);

  bool get _badgeOnCard1 => _assessmentLevel != null && _assessmentLevel! <= 1;

  bool get _badgeOnCard2 => _assessmentLevel != null && _assessmentLevel! >= 2;

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

  bool get _canContinue => _selectedCard != null;

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
                    onPressed:
                        widget.onBack ?? () => Navigator.pop(context),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/mascot/emotions/sage_curious.png',
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
                              "¡Perfecto! Veamos desde dónde arrancamos tu entrenamiento.",
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

            // ── Cards ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: Column(
                  children: [
                    Expanded(
                      child: _buildCard(
                        index: 0,
                        icon: Icons.menu_book,
                        iconColor: const Color(0xFFFFA726),
                        title: "¿Es tu primera vez en ciberdefensa?",
                        subtitle:
                            "¡Empieza desde cero y forja tu escudo!",
                        showBadge: _badgeOnCard1,
                        dark: dark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildCard(
                        index: 1,
                        icon: Icons.radar,
                        iconColor: const Color(0xFF00BCD4),
                        title: "¿Ya tienes nivel hacker?",
                        subtitle:
                            "¡Haz la prueba de nivel y sáltate lo básico!",
                        showBadge: _badgeOnCard2,
                        dark: dark,
                      ),
                    ),
                  ],
                ),
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
                        : dark ? Colors.grey[850] : Colors.grey.shade200,
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

  Widget _buildCard({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool showBadge,
    required bool dark,
  }) {
    final isSelected = _selectedCard == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCard = index);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? PremiumColors.primaryAccent.withValues(alpha: 0.08)
              : (dark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? PremiumColors.primaryAccent
                : (dark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.grey.withValues(alpha: 0.30)),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: iconColor, size: 36),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isSelected
                                ? (dark ? Colors.white : Colors.black87)
                                : (dark
                                    ? Colors.white.withValues(alpha: 0.90)
                                    : Colors.black87),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: dark ? Colors.white.withValues(alpha: 0.55) : Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showBadge)
              Positioned(
                top: -10,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'RECOMENDADO',
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
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
