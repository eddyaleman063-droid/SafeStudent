import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/sage_ai_provider.dart';

class LockedGatekeeper extends StatelessWidget {
  final SageAiChatState sage;
  final bool dark;
  const LockedGatekeeper({super.key, required this.sage, required this.dark});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [const Color(0xFFF5F7FA), const Color(0xFFE8ECF1)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PremiumColors.primaryAccent.withValues(alpha: 0.1),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/mascot/emotions/sage_thinking.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.psychology_rounded,
                    size: 56,
                    color: PremiumColors.primaryAccent.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              l.tutorLocked,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Text(
                l.tutorLockedDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white38 : Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl * 2),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: sage.progress,
                      backgroundColor: dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation<Color>(PremiumColors.primaryAccent),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.tutorLessonsProgress(sage.lessonsCompleted, sage.lessonsRequired),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: PremiumColors.primaryAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl * 2),
              child: Text(
                _motivationalMessage(l),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: dark ? Colors.white24 : Colors.black26,
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  String _motivationalMessage(AppLocalizations l) {
    final done = sage.lessonsCompleted;
    final need = sage.lessonsRequired - done;
    if (need <= 0) return '';
    if (need <= 3) return l.tutorMotivationAlmost(need);
    if (need <= 5) return l.tutorMotivationGood(need);
    return l.tutorMotivationGeneral;
  }
}
