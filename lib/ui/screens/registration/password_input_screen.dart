import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/l10n/app_localizations.dart';

class PasswordInputScreen extends ConsumerWidget {
  final VoidCallback onContinue;

  const PasswordInputScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(registrationFunnelProvider);
    final passwordValid = ref.watch(funnelPasswordValidProvider);

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                l.regPasswordTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.regPasswordDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _PasswordField(dark: dark),
              if (state.password.isNotEmpty && !passwordValid)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    l.authPasswordMinError,
                    style: const TextStyle(
                      fontSize: 13,
                      color: PremiumColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: passwordValid ? onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PremiumColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    disabledForegroundColor: dark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: passwordValid ? 4 : 0,
                  ),
                  child: Text(l.continueText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

class _PasswordField extends ConsumerStatefulWidget {
  final bool dark;
  const _PasswordField({required this.dark});

  @override
  ConsumerState<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends ConsumerState<_PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscured,
      style: TextStyle(
        fontSize: 16,
        color: widget.dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: '••••••',
        hintStyle: TextStyle(
          fontSize: 16,
          color: widget.dark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.15),
        ),
        filled: true,
        fillColor: widget.dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        prefixIcon: const Icon(Icons.lock_rounded, color: PremiumColors.primary, size: 20),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscured = !_obscured),
          child: Icon(
            _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: widget.dark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.3),
            size: 20,
          ),
        ),
      ),
      onChanged: (value) {
        ref.read(registrationFunnelProvider.notifier).setPassword(value);
      },
    );
  }
}
