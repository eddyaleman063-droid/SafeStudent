// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class ReferralSourceScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const ReferralSourceScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  State<ReferralSourceScreen> createState() => _ReferralSourceScreenState();
}

class _ReferralSourceScreenState extends State<ReferralSourceScreen> {
  int? _selectedIndex;
  bool _isPressed = false;

  static const _progressValue = 0.50;

  static const _sourceLabels = [
    'YouTube',
    'TikTok',
    'Instagram / Facebook',
    'Búsqueda en Google',
    'Play Store',
    'Recomendación de amigos',
    'Otro',
  ];

  void _onTapUp() {
    setState(() => _isPressed = false);
    if (_selectedIndex == null) return;
    HapticFeedback.mediumImpact();
    widget.onContinue?.call();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Block 1: Header (fixed) ──
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

            // ── Block 2: Mascot (fixed) ──
            RepaintBoundary(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
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
                              "¿Cómo descubriste la existencia de SAGEN?",
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

            // ── Block 3: Scrollable options (expanded) ──
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                itemCount: _sourceLabels.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 64,
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
                          _brandLogo(index),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _sourceLabels[index],
                              style: TextStyle(
                                color: dark ? Colors.white.withValues(alpha: 0.90) : Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
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

            // ── Block 4: Bottom button (fixed) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
              child: GestureDetector(
                onTapDown: _selectedIndex != null
                    ? (_) => setState(() => _isPressed = true)
                    : null,
                onTapUp: _selectedIndex != null ? (_) => _onTapUp() : null,
                onTapCancel: _selectedIndex != null
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
                    color: _selectedIndex != null
                        ? PremiumColors.primaryAccent
                        : (dark ? Colors.grey[850] : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isPressed || _selectedIndex == null
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
                        color: _selectedIndex != null
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

// ── Brand logo helpers ──────────────────────────────────────

Widget _brandLogo(int index) {
  switch (index) {
    case 0:
      return _squared(const Color(0xFFFF0000), Icons.play_arrow, Colors.white);
    case 1:
      return _squared(const Color(0xFF010101), Icons.music_note,
          const Color(0xFF00F2EA));
    case 2:
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFF77737)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
      );
    case 3:
      return const ImageIcon(
        AssetImage('assets/ui/google_logo.png'),
        size: 24,
      );
    case 4:
      return _squared(const Color(0xFF3DDC84), Icons.play_circle, Colors.white);
    case 5:
      return _squared(null, Icons.favorite, const Color(0xFFE91E63));
    case 6:
      return _squared(null, Icons.more_horiz, Colors.grey);
    default:
      return const SizedBox(width: 32, height: 32);
  }
}

Widget _squared(Color? bg, IconData icon, Color iconColor) {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    child: Icon(icon, color: iconColor, size: 20),
  );
}
