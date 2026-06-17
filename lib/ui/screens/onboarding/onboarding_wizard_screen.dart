import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/onboarding_wizard_config.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import '../../../services/experience_service.dart';
import '../../widgets/onboarding/wizard_top_bar.dart';
import '../../widgets/onboarding/wizard_sage_section.dart';
import '../../widgets/onboarding/wizard_bottom_bar.dart';
import '../../widgets/onboarding/wizard_summary_row.dart';
import 'package:sagen/l10n/app_localizations.dart';

class OnboardingWizardScreen extends ConsumerStatefulWidget {
  final bool isFirstLaunch;
  const OnboardingWizardScreen({super.key, this.isFirstLaunch = false});

  @override
  ConsumerState<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends ConsumerState<OnboardingWizardScreen> {
  late PageController _pageCtrl;
  final _exp = ExperienceService.instance;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  AppLocalizations get _l => AppLocalizations.of(context)!;

  Color get _bgColor => _isDark ? PremiumColors.deepBackground : const Color(0xFFF0F4FF);
  Color get _textPrimary => _isDark ? Colors.white : const Color(0xFF1A1A2E);
  Color get _textSecondary => _isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF1A1A2E).withValues(alpha: 0.7);
  Color get _cardBg => _isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04);
  Color get _cardSelectedBg => _isDark ? PremiumColors.splashBlue.withValues(alpha: 0.12) : PremiumColors.splashBlue.withValues(alpha: 0.12);
  Color get _cardBorder => _isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);
  Color get _cardSelectedBorder => PremiumColors.splashBlue.withValues(alpha: 0.5);
  Color get _iconColor => _isDark ? Colors.white38 : Colors.black38;
  Color get _iconSelectedColor => PremiumColors.splashBlue;
  Color get _subtitleColor => _isDark ? Colors.white.withValues(alpha: 0.4) : const Color(0xFF1A1A2E).withValues(alpha: 0.4);

  void _animateToPage(int index) {
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _goNext() {
    final notifier = ref.read(onboardingWizardProvider.notifier);
    notifier.nextStep();
    _animateToPage(ref.read(onboardingWizardProvider).currentIndex);
  }

  void _goBack() {
    final state = ref.read(onboardingWizardProvider);
    if (state.currentIndex > 0) {
      final notifier = ref.read(onboardingWizardProvider.notifier);
      notifier.previousStep();
      _animateToPage(ref.read(onboardingWizardProvider).currentIndex);
    } else {
      Navigator.pop(context);
    }
  }

  void _completeWizard() {
    _exp.mediumHaptic();
    context.goNamed('onboarding-flow');
  }

  String _sageMessageForStep(int index, OnboardingWizardState wizardState, AppLocalizations l) {
    final config = OnboardingWizardConfig.steps[index];
    if (index == 7) {
      final data = wizardState.sectionData[7];
      if (data is List && data.length == 1) {
        final val = data.first.toString();
        switch (val) {
          case '7': return l.onboardingSageStart;
          case '14': return l.onboardingSageTwoWeeks;
          case '30': return l.onboardingSageMonth;
          case '50': return l.onboardingSage50Days;
        }
      } else if (data is List && data.length > 1) {
        return l.onboardingSageExcellent;
      }
    }
    return config.sageMessage;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingWizardProvider);
    final canContinue = ref.watch(onboardingCanContinueProvider);
    final config = OnboardingWizardConfig.steps[state.currentIndex];

    return PopScope(
      canPop: state.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            children: [
              WizardTopBar(currentIndex: state.currentIndex, onBack: _goBack),
              WizardSageSection(
                key: ValueKey('sage_${state.currentIndex}_${state.sectionData.hashCode}'),
                emotion: config.emotion,
                message: _sageMessageForStep(state.currentIndex, state, _l),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: OnboardingWizardConfig.totalSteps,
                  itemBuilder: (context, i) => _buildStep(i),
                ),
              ),
              WizardBottomBar(
                currentIndex: state.currentIndex,
                canContinue: canContinue,
                onNext: _goNext,
                onComplete: _completeWizard,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int index) {
    switch (index) {
      case 0: return _buildPresentationStep();
      case 1: return _buildSingleChoiceStep(1);
      case 2: return _buildLevelStep();
      case 3: return _buildMultiChoiceStep(3);
      case 4: return _buildSingleChoiceStep(4);
      case 5: return _buildMultiChoiceStep(5);
      case 6: return _buildGoalStep();
      case 7: return _buildCommitmentStep();
      case 8: return _buildConfirmationStep();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildPresentationStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            _l.regWelcomeSagen,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _textPrimary,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              _l.onboardingDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildSingleChoiceStep(int index) {
    final config = OnboardingWizardConfig.steps[index];
    final state = ref.watch(onboardingWizardProvider);
    final selected = state.sectionData[index] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            config.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < config.options.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.sm),
                    _singleChoiceTile(config.options[i], selected == config.options[i].value, () {
                      _exp.lightHaptic();
                      ref.read(onboardingWizardProvider.notifier).setSectionData(index, config.options[i].value);
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleChoiceTile(WizardOption opt, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _exp.fast,
        curve: AppEasing.entrance,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? _cardSelectedBg : _cardBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? _cardSelectedBorder : _cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(opt.icon, size: 22, color: isSelected ? _iconSelectedColor : _iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                opt.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? _textPrimary : _textSecondary,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              size: 22,
              color: isSelected ? _iconSelectedColor : _iconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _multiChoiceTile(WizardOption opt, List<String> selected, int stepIndex) {
    final isSelected = selected.contains(opt.value);
    return GestureDetector(
      onTap: () {
        _exp.lightHaptic();
        final updated = List<String>.from(selected);
        if (updated.contains(opt.value)) {
          updated.remove(opt.value);
        } else {
          updated.add(opt.value);
        }
        ref.read(onboardingWizardProvider.notifier).setSectionData(stepIndex, updated);
      },
      child: AnimatedContainer(
        duration: _exp.fast,
        curve: AppEasing.entrance,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? _cardSelectedBg : _cardBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? _cardSelectedBorder : _cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(opt.icon, size: 22, color: isSelected ? _iconSelectedColor : _iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                opt.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? _textPrimary : _textSecondary,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              size: 22,
              color: isSelected ? _iconSelectedColor : _iconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelTile(WizardOption opt, bool isSelected, VoidCallback onTap) {
    final levelVal = int.tryParse(opt.value) ?? 0;
    final fill = levelVal / 5.0;
    final accentColor = opt.color ?? PremiumColors.splashBlue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _exp.fast,
        curve: AppEasing.entrance,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.1) : _cardBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? accentColor.withValues(alpha: 0.4) : _cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(opt.icon, size: 22, color: isSelected ? accentColor : _iconColor),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opt.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? _textPrimary : _textSecondary,
                        ),
                      ),
                      if (opt.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          opt.subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? _textSecondary.withValues(alpha: 0.7) : _subtitleColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  size: 22,
                  color: isSelected ? accentColor : _iconColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: isSelected ? fill : 0.0,
                backgroundColor: _isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commitmentTile(WizardOption opt, List<String> selected) {
    final isSelected = selected.contains(opt.value);
    final accentColor = opt.color ?? PremiumColors.splashBlue;
    return GestureDetector(
      onTap: () {
        _exp.lightHaptic();
        final updated = List<String>.from(selected);
        if (updated.contains(opt.value)) {
          updated.remove(opt.value);
        } else {
          updated.add(opt.value);
        }
        ref.read(onboardingWizardProvider.notifier).setSectionData(7, updated);
      },
      child: AnimatedContainer(
        duration: _exp.fast,
        curve: AppEasing.entrance,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [accentColor.withValues(alpha: 0.15), accentColor.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : _cardBg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? accentColor.withValues(alpha: 0.5) : _cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? accentColor.withValues(alpha: 0.2) : (_isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(opt.icon, size: 26, color: accentColor),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? _textPrimary : _textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.diamond_rounded,
                        size: 14,
                        color: PremiumColors.splashBlue.withValues(alpha: isSelected ? 1.0 : 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        opt.subtitle ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: PremiumColors.splashBlue.withValues(alpha: isSelected ? 0.9 : 0.6),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : (_isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2)),
                  width: 2,
                ),
                color: isSelected ? accentColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelStep() {
    final config = OnboardingWizardConfig.steps[2];
    final state = ref.watch(onboardingWizardProvider);
    final selected = state.sectionData[2] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            config.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < config.options.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.sm),
                    _levelTile(config.options[i], selected == config.options[i].value, () {
                      _exp.lightHaptic();
                      ref.read(onboardingWizardProvider.notifier).setSectionData(2, config.options[i].value);
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiChoiceStep(int index) {
    final config = OnboardingWizardConfig.steps[index];
    final state = ref.watch(onboardingWizardProvider);
    final selected = (state.sectionData[index] as List<String>?) ?? <String>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            config.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < config.options.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.sm),
                    _multiChoiceTile(config.options[i], selected, index),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStep() {
    final config = OnboardingWizardConfig.steps[6];
    final state = ref.watch(onboardingWizardProvider);
    final selected = state.sectionData[6] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            config.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...config.options.map((opt) {
            final isSelected = selected == opt.value;
            final accentColor = opt.color ?? PremiumColors.splashBlue;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GestureDetector(
                onTap: () {
                  _exp.lightHaptic();
                  ref.read(onboardingWizardProvider.notifier).setSectionData(6, opt.value);
                },
                child: AnimatedContainer(
                  duration: _exp.fast,
                  curve: AppEasing.entrance,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [accentColor.withValues(alpha: 0.15), accentColor.withValues(alpha: 0.05)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : _cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: isSelected ? accentColor.withValues(alpha: 0.5) : _cardBorder,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected ? accentColor.withValues(alpha: 0.2) : (_isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(opt.icon, size: 26, color: accentColor),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opt.label,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? _textPrimary : _textSecondary,
                              ),
                            ),
                            if (opt.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                opt.subtitle!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? _textSecondary.withValues(alpha: 0.7) : _subtitleColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? accentColor : (_isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2)),
                            width: 2,
                          ),
                          color: isSelected ? accentColor : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommitmentStep() {
    final config = OnboardingWizardConfig.steps[7];
    final state = ref.watch(onboardingWizardProvider);
    final selected = (state.sectionData[7] as List<String>?) ?? <String>[];
    final sageMsg = _sageMessageForStep(7, state, _l);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          WizardSageBubble(
            message: sageMsg,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            config.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < config.options.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.md),
                    _commitmentTile(config.options[i], selected),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    final state = ref.watch(onboardingWizardProvider);

    final referral = state.sectionData[1] as String? ?? '—';
    final knowledge = state.sectionData[2] as String? ?? '—';
    final reasons = (state.sectionData[3] as List<String>?) ?? [];
    final interest = state.sectionData[4] as String? ?? '—';
    final habits = (state.sectionData[5] as List<String>?) ?? [];
    final goal = state.sectionData[6] as String? ?? '—';
    final commitments = (state.sectionData[7] as List<String>?) ?? [];

    final config = OnboardingWizardConfig.steps[8];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Text(
              config.question,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            WizardSummaryRow(label: _l.summaryOrigin, value: referral),
            WizardSummaryRow(label: _l.summaryKnowledge, value: knowledge),
            WizardSummaryRow(label: _l.summaryInterest, value: interest),
            if (reasons.isNotEmpty)
              WizardSummaryRow(label: _l.summaryMotivations, value: reasons.join(', ')),
            if (habits.isNotEmpty)
              WizardSummaryRow(label: _l.summaryLearning, value: habits.join(', ')),
            WizardSummaryRow(label: _l.summaryDailyGoal, value: '$goal min'),
            if (commitments.isNotEmpty)
              WizardSummaryRow(label: _l.summaryCommitment, value: _l.commitDays(commitments.length)),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: PremiumColors.splashBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: PremiumColors.splashBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: PremiumColors.splashBlue, size: 20),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _l.summaryReady,
                      style: TextStyle(
                        fontSize: 13,
                        color: _textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
