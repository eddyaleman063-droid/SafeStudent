import 'package:flutter/material.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../ui/widgets/common/sage_emotion_widget.dart';
import '../../../services/sage_emotion_service.dart';
import '../../widgets/weekly_calendar_widget.dart';
import 'package:sagen/l10n/app_localizations.dart';

class CommitmentSelectionScreen extends StatefulWidget {
  final VoidCallback onCommit;

  const CommitmentSelectionScreen({super.key, required this.onCommit});

  @override
  State<CommitmentSelectionScreen> createState() => _CommitmentSelectionScreenState();
}

class _CommitmentSelectionScreenState extends State<CommitmentSelectionScreen> {
  int? _selectedDays;
  final _weekDays = <String, bool>{};

  static const _options = [7, 14, 30, 50];

  String _goalText(int days, AppLocalizations l) {
    if (days == 7) return l.commit1Week;
    if (days == 14) return l.commit2Weeks;
    if (days == 30) return l.commit1Month;
    return l.commitDays(50);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              const Center(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: SageEmotionWidget(
                    emotion: SageEmotion.thinking,
                    size: 90,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l.commitChooseGoal,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.commitChooseGoalDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ..._options.map((days) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDays = days),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          color: _selectedDays == days
                              ? PremiumColors.streakOrange.withValues(alpha: 0.1)
                              : dark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.black.withValues(alpha: 0.03),
                          border: Border.all(
                            color: _selectedDays == days
                                ? PremiumColors.streakOrange
                                : dark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.06),
                            width: _selectedDays == days ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedDays == days
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              size: 22,
                              color: _selectedDays == days
                                  ? PremiumColors.streakOrange
                                  : dark
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : Colors.black.withValues(alpha: 0.2),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l.commitDays(days),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedDays == days
                                          ? PremiumColors.streakOrange
                                          : dark
                                              ? Colors.white.withValues(alpha: 0.85)
                                              : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    _goalText(days, l),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: dark ? Colors.white.withValues(alpha: 0.4) : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedDays == days)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  color: PremiumColors.streakOrange,
                                ),
                                child: Text(
                                  l.commitSelected,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )),
              if (_selectedDays != null) ...[
                const SizedBox(height: AppSpacing.xl),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    color: dark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
                    border: Border.all(
                      color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l.commitYourGoal(_selectedDays!),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: PremiumColors.streakOrange,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      WeeklyCalendarWidget(
                        currentStreak: 0,
                        streakGoal: _selectedDays!,
                        weekDays: _weekDays,
                        isDark: dark,
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _selectedDays != null ? widget.onCommit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.streakOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    disabledForegroundColor: dark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: _selectedDays != null ? 4 : 0,
                  ),
                  child: Text(
                    l.commitButton,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
