// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class RouteSelectionScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const RouteSelectionScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  int? _selectedRouteIndex;
  bool _isPressed = false;

  static const _progressValue = 0.35;

  static const _routes = [
    ('🛡️', 'Defensa Personal Digital'),
    ('💻', 'Hacking Ético & Redes'),
    ('⚙️', 'Desarrollo Seguro (DevSecOps)'),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: back arrow + progress bar ──
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

            // ── Horizontal mascot block ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mascot on the left
                  Image.asset(
                    'assets/mascot/emotions/sage_thinking.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 8),
                  // Speech bubble with left-pointing arrow
                  Expanded(
                    child: RepaintBoundary(
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
                              "¿Qué área del entorno digital te gustaría "
                              "dominar primero?",
                              style: TextStyle(
                                color: dark ? Colors.white : Colors.black87,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                          // Left-pointing arrow
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Section subtitle ──
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: AppSpacing.xxl, bottom: 12),
                child: Text(
                  'Rutas de entrenamiento disponibles:',
                  style: TextStyle(
                  color: dark ? Colors.white.withValues(alpha: 0.45) : Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // ── Route options ──
            Expanded(
              child: RepaintBoundary(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  itemCount: _routes.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedRouteIndex == index;
                    final (emoji, title) = _routes[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRouteIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            Text(emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: dark ? Colors.white.withValues(alpha: 0.90) : Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
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
            ),

            // ── Conditional bottom button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
              child: GestureDetector(
                onTapDown: _selectedRouteIndex != null
                    ? (_) => setState(() => _isPressed = true)
                    : null,
                onTapUp: _selectedRouteIndex != null
                    ? (_) {
                        setState(() => _isPressed = false);
                        HapticFeedback.lightImpact();
                        widget.onContinue?.call();
                      }
                    : null,
                onTapCancel: _selectedRouteIndex != null
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
                    color: _selectedRouteIndex != null
                        ? PremiumColors.primaryAccent
                        : (dark ? Colors.grey[850] : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isPressed || _selectedRouteIndex == null
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
                        color: _selectedRouteIndex != null
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
