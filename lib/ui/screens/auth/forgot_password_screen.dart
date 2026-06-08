// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/auth_models.dart';
import 'package:sagen/services/auth_service.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import 'package:sagen/ui/widgets/keyboard_aware_layout.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      SagenNotification.show(context, message: AppLocalizations.of(context)!.authEnterEmailError, type: NotificationType.warning);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() => _sent = true);
      SagenNotification.show(context, message: AppLocalizations.of(context)!.authRecoveryEmailSentMessage, type: NotificationType.success);
    } on AuthException catch (e) {
      if (!mounted) return;
      SagenNotification.show(context, message: e.localizedMessage(AppLocalizations.of(context)!), type: NotificationType.error);
    } catch (_) {
      if (!mounted) return;
      SagenNotification.show(context, message: AppLocalizations.of(context)!.authSendEmailError, type: NotificationType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.authForgotPasswordTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: dark ? Colors.white : Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: KeyboardAwareLayout(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _sent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 64, color: const Color(0xFF66BB6A).withValues(alpha: 0.8)),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.authRecoveryEmailSentTitle,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.authRecoveryEmailSentDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: dark ? Colors.white.withValues(alpha: 0.55) : Colors.black54, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PremiumColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(AppLocalizations.of(context)!.authBack, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: dark ? Colors.white : Colors.black87)),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.authForgotPasswordTitle,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: dark ? Colors.white.withValues(alpha: 0.95) : Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.authForgotPasswordDesc,
                        style: TextStyle(fontSize: 14, color: dark ? Colors.white.withValues(alpha: 0.55) : Colors.black54, height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: dark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: dark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.30)),
                        ),
                        child: TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.authEmailLabel,
                            hintStyle: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.30), fontSize: 15),
                            prefixIcon: Icon(Icons.mail_outline, size: 20, color: dark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.40)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PremiumColors.primary,
                            foregroundColor: dark ? Colors.white : Colors.black87,
                            disabledBackgroundColor: dark ? Colors.white12 : Colors.black12,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(dark ? Colors.white : Colors.black87)))
                              : Text(AppLocalizations.of(context)!.authSendLink, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
