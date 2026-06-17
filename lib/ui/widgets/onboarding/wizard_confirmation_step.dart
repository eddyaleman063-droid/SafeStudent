import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';

import 'package:sagen/core/theme/app_colors.dart';
import '../../../config/onboarding_wizard_config.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../l10n/app_localizations.dart';
import 'wizard_summary_row.dart' show WizardSummaryRow;

class WizardConfirmationStep extends ConsumerWidget {
  const WizardConfirmationStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final textPrimary = context.textPrimary;
    final textSecondary = cs.onSurface.withValues(alpha: 0.7);
    final l = AppLocalizations.of(context)!;

    final state = ref.watch(onboardingWizardProvider);
    final referral = state.sectionData[1] as String? ?? '—';
    final knowledge = state.sectionData[2] as String? ?? '—';
    final reasons = (state.sectionData[3] as List<String>?) ?? [];
    final habits = (state.sectionData[4] as List<String>?) ?? [];
    final goal = state.sectionData[5] as String? ?? '—';
    final commitments = (state.sectionData[6] as List<String>?) ?? [];
    final config = OnboardingWizardConfig.steps[7];

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
                color: textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            WizardSummaryRow(label: l.summaryOrigin, value: referral),
            WizardSummaryRow(label: l.summaryKnowledge, value: knowledge),
            if (reasons.isNotEmpty)
              WizardSummaryRow(label: l.summaryMotivations, value: reasons.join(', ')),
            if (habits.isNotEmpty)
              WizardSummaryRow(label: l.summaryLearning, value: habits.join(', ')),
            WizardSummaryRow(label: l.summaryDailyGoal, value: '$goal min'),
            if (commitments.isNotEmpty)
              WizardSummaryRow(label: l.summaryCommitment, value: l.commitDays(commitments.length)),
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
                      l.summaryReady,
                      style: TextStyle(
                        fontSize: 13,
                        color: textSecondary,
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
