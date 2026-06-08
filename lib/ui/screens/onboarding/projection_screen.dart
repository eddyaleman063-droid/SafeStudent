// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class ProjectionScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const ProjectionScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  State<ProjectionScreen> createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends State<ProjectionScreen> {
  bool _isPressed = false;

  static const double _progressValue = 0.95;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.lightImpact();
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

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                        'assets/mascot/emotions/sage_happy_wings.png',
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
                                "¡Esto es lo que dominarás en 3 meses!",
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

              const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),

              // ── Benefit items ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: Column(
                  children: [
                    _BenefitItem(
                      icon: Icons.shield,
                      iconColor: const Color(0xFF9B59B6),
                      title: "Navega con inmunidad",
                      subtitle:
                          "Detecta estafas, links maliciosos y phishing antes de dar un solo clic.",
                    ),
                    const SizedBox(height: 24),
                    _BenefitItem(
                      icon: Icons.fingerprint,
                      iconColor: const Color(0xFF00BCD4),
                      title: "Blinda tus cuentas",
                      subtitle:
                          "Protege tus redes y cuentas de videojuegos contra hackeos y robos.",
                    ),
                    const SizedBox(height: 24),
                    _BenefitItem(
                      icon: Icons.bolt,
                      iconColor: const Color(0xFFFFA726),
                      title: "Forja una mentalidad hacker",
                      subtitle:
                          "Recordatorios estratégicos, retos diarios y tácticas de defensa digital.",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl * 2),

              // ── Bottom button ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
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
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _BenefitItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                softWrap: true,
                style: TextStyle(
                  color: dark ? Colors.white.withValues(alpha: 0.60) : Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
