import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/models/chest_type.dart';
import 'package:sagen/services/chest_event_bus.dart';
import 'package:sagen/services/device_tier.dart';
import 'package:sagen/ui/widgets/animations/gem_rain_animation.dart';
import 'package:sagen/ui/widgets/chest_widget.dart';
import 'package:sagen/ui/widgets/gem_pile_widget.dart';

class ChestRewardDialog extends StatefulWidget {
  final ChestRewardData reward;
  final VoidCallback? onDismiss;

  const ChestRewardDialog({super.key, required this.reward, this.onDismiss});

  static Future<void> show(BuildContext context, ChestRewardData reward) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChestRewardDialog(reward: reward),
    );
  }

  @override
  State<ChestRewardDialog> createState() => _ChestRewardDialogState();
}

class _ChestRewardDialogState extends State<ChestRewardDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _revealCtrl;
  bool _showRewards = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _onChestOpened() {
    if (_dismissed) return;
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_dismissed || !mounted) return;
      setState(() => _showRewards = true);
      _revealCtrl.forward().then((_) {
        if (!_dismissed && mounted) {
          _revealCtrl.reverse();
        }
      });
    });
  }

  void _dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    widget.onDismiss?.call();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final r = widget.reward;

    return PopScope(
      canPop: !_dismissed,
      child: Scaffold(
        backgroundColor: (dark ? const Color(0xFF0A0E1A) : Colors.white).withValues(alpha: 0.96),
        body: SafeArea(
          child: GestureDetector(
            onTap: _showRewards ? _dismiss : null,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ChestWidget(
                          key: ValueKey('chest_${r.type.name}'),
                          type: r.type,
                          size: 180,
                          animate: true,
                          onOpenComplete: _onChestOpened,
                        ),
                        if (!_showRewards && !LowEndDeviceDetector.instance.reduceAnimations)
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Lottie.asset(
                              'assets/animations/sparkle.json',
                              repeat: true,
                              animate: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _showRewards
                        ? _RewardsPanel(
                            reward: r,
                            animation: _revealCtrl,
                            onDismiss: _dismiss,
                          )
                        : _TitlePanel(type: r.type, title: r.title),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitlePanel extends StatelessWidget {
  final ChestType type;
  final String? title;
  const _TitlePanel({required this.type, this.title});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title ?? l.chestTitle(type.localizedLabel(l)),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: PremiumColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.chestTapToOpen,
          style: AppTextStyle.body.copyWith(color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class _RewardsPanel extends StatelessWidget {
  final ChestRewardData reward;
  final AnimationController animation;
  final VoidCallback onDismiss;

  const _RewardsPanel({
    required this.reward,
    required this.animation,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final r = reward;

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            r.title ?? l.chestOpenedTitle(r.type.localizedLabel(l)),
            style: AppTextStyle.headline.copyWith(
              color: PremiumColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          if (r.message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                r.message!,
                style: AppTextStyle.subtitle.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 8),
          if (r.gems > 0)
            GemRainAnimation(
              gemCount: r.gems.clamp(5, 25),
              totalGems: r.gems,
              height: 120,
              gemColor: r.type.gemColor,
            ),
          if (r.gems > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GemPileWidget(
                gemCount: r.gems.clamp(1, 40),
                maxSize: 80 + r.gems.clamp(0, 30) * 1.5,
                itemSize: 14 + r.gems.clamp(0, 20) * 0.3,
                gemColor: r.type.gemColor,
              ),
            ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (r.xp > 0)
                _RewardChip(
                  icon: Icons.auto_awesome_rounded,
                  label: '+${r.xp} XP',
                  color: const Color(0xFF7C3AED),
                ),
              if (r.streakShields != null && r.streakShields! > 0)
                _RewardChip(
                  icon: Icons.ac_unit_rounded,
                  label: '×${r.streakShields}',
                  color: PremiumColors.premiumBlue,
                ),
              if (r.xpBoost)
                const _RewardChip(
                  icon: Icons.bolt_rounded,
                  label: '×2 XP',
                  color: Color(0xFFFF6D00),
                ),
              if (r.gemMultiplier)
                _RewardChip(
                  icon: Icons.diamond_rounded,
                  label: l.gemMultiplierLabel,
                  color: const Color(0xFFE040FB),
                ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: r.type.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: Text(l.chestCollect, style: AppTextStyle.cardTitle),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _RewardChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyle.bodyBold.copyWith(color: color)),
        ],
      ),
    );
  }
}


