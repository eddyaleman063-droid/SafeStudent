import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/providers/providers.dart';

import '../../../config/onboarding_wizard_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/experience_service.dart';
import 'wizard_commitment_tile.dart';
import 'wizard_sage_section.dart';

class WizardCommitmentStep extends ConsumerWidget {
  final int stepIndex;
  final String Function(int, dynamic, AppLocalizations) sageMessageForStep;

  const WizardCommitmentStep({
    super.key,
    required this.stepIndex,
    required this.sageMessageForStep,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = context.textPrimary;

    final config = OnboardingWizardConfig.steps[stepIndex];
    final state = ref.watch(onboardingWizardProvider);
    final selected = (state.sectionData[stepIndex] as List<String>?) ?? <String>[];
    final l = AppLocalizations.of(context)!;
    final sageMsg = sageMessageForStep(stepIndex, state, l);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          WizardSageBubble(message: sageMsg),
          const SizedBox(height: AppSpacing.xl),
          Text(
            config.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
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
                    WizardCommitmentTile(
                      option: config.options[i],
                      isSelected: selected.contains(config.options[i].value),
                      onTap: () {
                        ExperienceService.instance.lightHaptic();
                        final updated = List<String>.from(selected);
                        if (updated.contains(config.options[i].value)) {
                          updated.remove(config.options[i].value);
                        } else {
                          updated.add(config.options[i].value);
                        }
                        ref.read(onboardingWizardProvider.notifier).setSectionData(stepIndex, updated);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
