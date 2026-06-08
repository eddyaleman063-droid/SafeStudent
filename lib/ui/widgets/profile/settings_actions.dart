import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/experience_service.dart';
import 'package:sagen/services/notification_service.dart';
import 'package:sagen/ui/widgets/profile/settings_sheet.dart';

class SettingsActions extends ConsumerWidget {
  final bool dark;
  const SettingsActions({super.key, required this.dark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showSettings(context),
            icon: const Icon(Icons.tune_rounded, size: 16),
            label: Text(l.settingsTitle),
            style: OutlinedButton.styleFrom(
              foregroundColor: dark ? Colors.white70 : Colors.black54,
              side: BorderSide(color: dark ? Colors.white12 : Colors.black12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout_rounded, size: 16),
            label: Text(l.settingsLogout),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF6B6B),
              side: BorderSide(color: const Color(0xFFFF6B6B).withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    ExperienceService.instance.lightHaptic();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsSheet(),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    ExperienceService.instance.lightHaptic();
    showDialog(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          title: Text(l.settingsLogout),
          content: Text(l.settingsLogoutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                NotificationService.instance.cancelAll();
                await ref.read(authProvider.notifier).signOut();
                if (ctx.mounted) {
                  ctx.goNamed('welcome');
                }
              },
              child: Text(l.settingsLogout, style: const TextStyle(color: Color(0xFFFF6B6B))),
            ),
          ],
        );
      },
    );
  }
}
