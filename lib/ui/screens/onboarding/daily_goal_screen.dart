// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';

class DailyGoalConfig {
  final String label;
  final int minutes;
  final int questionsPerSession;

  const DailyGoalConfig({
    required this.label,
    required this.minutes,
    required this.questionsPerSession,
  });
}

const List<DailyGoalConfig> dailyGoalOptions = [
  DailyGoalConfig(label: "Relajado", minutes: 3, questionsPerSession: 5),
  DailyGoalConfig(label: "Normal", minutes: 10, questionsPerSession: 12),
  DailyGoalConfig(label: "Serio", minutes: 15, questionsPerSession: 18),
  DailyGoalConfig(label: "Intenso", minutes: 30, questionsPerSession: 35),
];

class DailyGoalScreen extends ConsumerStatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const DailyGoalScreen({
    super.key,
    this.onContinue,
    this.onBack,
  });

  @override
  ConsumerState<DailyGoalScreen> createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends ConsumerState<DailyGoalScreen> {
  int? _selectedIndex;
  bool _isPressed = false;

  static const double _progressValue = 0.90;

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    HapticFeedback.mediumImpact();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    if (_selectedIndex != null) {
      final goal = dailyGoalOptions[_selectedIndex!];
      ref.read(dashboardProvider.notifier).setDailyGoalMinutes(goal.minutes);
      widget.onContinue?.call();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  bool get _canContinue => _selectedIndex != null;

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
                              "¿Cuál es tu meta diaria de aprendizaje?",
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

            const SizedBox(height: AppSpacing.xl),

            // ── Goal options ──
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                itemCount: dailyGoalOptions.length,
                itemBuilder: (context, index) {
                  final goal = dailyGoalOptions[index];
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 60,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${goal.minutes} min/día",
                            style: TextStyle(
                              color: dark ? Colors.white : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            goal.label,
                            style: TextStyle(
                              color: isSelected
                                  ? PremiumColors.primaryAccent
                                  : (dark ? Colors.white.withValues(alpha: 0.50) : Colors.black54),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
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
                      'MANTENER MI COMPROMISO',
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
