// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class QuizIntroScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const QuizIntroScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  State<QuizIntroScreen> createState() => _QuizIntroScreenState();
}

class _QuizIntroScreenState extends State<QuizIntroScreen> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.mediumImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Header: back arrow only ──
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
                ],
              ),
            ),

            // ── Center block: speech bubble + mascot ──
            Expanded(
              child: RepaintBoundary(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Speech bubble with RichText
                    Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
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
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: dark ? Colors.white : Colors.black87,
                            fontSize: 16,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: "¡Responde "),
                            TextSpan(
                              text: "8 preguntas rápidas",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(
                              text:
                                  " antes de tu primer entrenamiento digital!",
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Triangle arrow (rotated diamond)
                    const SizedBox(height: 8),
                    Transform.rotate(
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

                    const SizedBox(height: 12),

                    // Mascot
                    Image.asset(
                      'assets/mascot/emotions/sage_reading.png',
                      width: 180,
                      height: 180,
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom 3D button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  widget.onContinue?.call();
                },
                onTapCancel: () => setState(() => _isPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  transform: _isPressed
                      ? Matrix4.translationValues(0, 4, 0)
                      : Matrix4.identity(),
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryAccent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isPressed
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
                        color: dark ? Colors.white : Colors.black87,
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
