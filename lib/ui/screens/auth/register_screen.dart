// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/auth_models.dart';
import '../../../services/auth_service.dart';
import '../../../services/experience_service.dart';
import 'package:sagen/ui/widgets/common/sagen_notification.dart';
import '../../../ui/widgets/onboarding/legal_text_block.dart';
import '../../../ui/widgets/shimmer_loading.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final bool isOnboarding;
  final VoidCallback? onSwitchToLogin;
  final VoidCallback? onComplete;
  const RegisterScreen({super.key, this.isOnboarding = false, this.onSwitchToLogin, this.onComplete});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _fieldsValid = false;

  static const String _termsUrl = 'https://sagen.app/terms';
  static const String _privacyUrl = 'https://sagen.app/privacy';
  static final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_validateFields);
    _emailCtrl.addListener(_validateFields);
    _passwordCtrl.addListener(_validateFields);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_validateFields);
    _emailCtrl.removeListener(_validateFields);
    _passwordCtrl.removeListener(_validateFields);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _validateFields() {
    final nameOk = _nameCtrl.text.trim().isNotEmpty;
    final emailOk = _emailRegex.hasMatch(_emailCtrl.text.trim());
    final passOk = _passwordCtrl.text.length >= 6;
    final valid = nameOk && emailOk && passOk;
    if (valid != _fieldsValid) {
      setState(() => _fieldsValid = valid);
    }
    // validation state tracked via form field validators
  }

  Future<void> _handleRegister() async {
    if (!_fieldsValid || _isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final funnel = ref.read(registrationFunnelProvider.notifier);
    funnel.setAuthMethod('email');
    funnel.setName(_nameCtrl.text.trim());
    funnel.setEmail(_emailCtrl.text.trim());
    funnel.setPassword(_passwordCtrl.text);

    final authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signUpWithEmail(
        displayName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated || auth.showVerificationScreen) {
        ExperienceService.instance.successHaptic();
        widget.onComplete?.call();
        if (!widget.isOnboarding && mounted) Navigator.pop(context, true);
      } else if (auth.errorMessage != null) {
        SagenNotification.show(context, message: AuthException(auth.errorMessage!).localizedMessage(AppLocalizations.of(context)!), type: NotificationType.error);
      }
    } catch (_) {
      if (!mounted) return;
      SagenNotification.show(context, message: AppLocalizations.of(context)!.authCreateAccountError, type: NotificationType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleRegister() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final funnel = ref.read(registrationFunnelProvider.notifier);
    funnel.setAuthMethod('google');
    funnel.setName(_nameCtrl.text.trim());
    funnel.setEmail(_emailCtrl.text.trim());

    final authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithGoogle();
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        ExperienceService.instance.successHaptic();
        widget.onComplete?.call();
      } else if (auth.errorMessage != null) {
        SagenNotification.show(context, message: AuthException(auth.errorMessage!).localizedMessage(AppLocalizations.of(context)!), type: NotificationType.error);
      }
    } catch (_) {
      if (!mounted) return;
      SagenNotification.show(context, message: AppLocalizations.of(context)!.authRegisterGoogleError, type: NotificationType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleFacebookRegister() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final funnel = ref.read(registrationFunnelProvider.notifier);
    funnel.setAuthMethod('facebook');

    try {
      await ref.read(authServiceProvider).signInWithFacebook();
      if (!mounted) return;
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.refreshCurrentUser();
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        ExperienceService.instance.successHaptic();
        widget.onComplete?.call();
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      if (e.code != 'canceled') {
        SagenNotification.show(context, message: e.localizedMessage(AppLocalizations.of(context)!), type: NotificationType.error);
      }
    } catch (_) {
      if (!mounted) return;
      SagenNotification.show(context, message: AppLocalizations.of(context)!.authRegisterFacebookError, type: NotificationType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onClose() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onClose();
      },
      child: Scaffold(
        backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: dark ? Colors.white.withValues(alpha: 0.6) : Colors.black54),
                        onPressed: _onClose,
                      ),
                      const Spacer(),
                      Text(
                        l.authRegisterTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white.withValues(alpha: 0.80) : Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // ── Unified form container ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: dark ? Colors.white.withValues(alpha: 0.10) : Colors.grey.withValues(alpha: 0.30),
                        ),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameCtrl,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                            style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: l.authFullName,
                              hintStyle: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30), fontSize: 15),
                              prefixIcon: Icon(Icons.person_outline, size: 20, color: dark ? Colors.white.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.35)),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return l.authNameError;
                              return null;
                            },
                          ),
                          Divider(
                            height: 0,
                            color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.30),
                            indent: 16,
                            endIndent: 16,
                          ),
                          TextFormField(
                            controller: _emailCtrl,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                            style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: l.authEmailLabel,
                              hintStyle: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30), fontSize: 15),
                              prefixIcon: Icon(Icons.mail_outline, size: 20, color: dark ? Colors.white.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.35)),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return l.authEmailError;
                              if (!_emailRegex.hasMatch(v.trim())) return l.authEmailError;
                              return null;
                            },
                          ),
                          Divider(
                            height: 0,
                            color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.30),
                            indent: 16,
                            endIndent: 16,
                          ),
                          TextFormField(
                            controller: _passwordCtrl,
                            focusNode: _passwordFocus,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleRegister(),
                            style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: l.authPasswordMinHint,
                              hintStyle: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30), fontSize: 15),
                              prefixIcon: Icon(Icons.lock_outline, size: 20, color: dark ? Colors.white.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.35)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  size: 20,
                                  color: PremiumColors.primaryAccent,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return l.authPasswordError;
                              if (v.length < 6) return l.authPasswordMinHint;
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // ── Register button ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: _isLoading
                        ? ShimmerLoading(width: double.infinity, height: 52, borderRadius: AppRadius.lg)
                        : ElevatedButton(
                            onPressed: _fieldsValid ? _handleRegister : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _fieldsValid
                                  ? PremiumColors.primaryAccent
                                  : (dark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.15)),
                              foregroundColor: dark ? Colors.white : Colors.black87,
                              disabledBackgroundColor: dark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.15),
                              disabledForegroundColor: dark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              l.authCreateAccount,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 1),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                // ── Divider ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: dark ? Colors.white.withValues(alpha: 0.10) : Colors.grey.withValues(alpha: 0.40))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text(
                          l.authOrRegisterWith,
                          style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.35) : Colors.black54, fontSize: 13),
                        ),
                      ),
                      Expanded(child: Divider(color: dark ? Colors.white.withValues(alpha: 0.10) : Colors.grey.withValues(alpha: 0.40))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // ── Social buttons ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleGoogleRegister,
                            icon: Image.asset('assets/ui/google_logo.png', width: 20, height: 20),
                            label: Text('GOOGLE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: dark ? Colors.white : Colors.black87)),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: dark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.withValues(alpha: 0.10),
                              side: BorderSide(color: dark ? Colors.white.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.30)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleFacebookRegister,
                            icon: const Icon(Icons.facebook_rounded, size: 20, color: Color(0xFF1877F2)),
                            label: Text('FACEBOOK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: dark ? Colors.white : Colors.black87)),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: dark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.withValues(alpha: 0.10),
                              side: BorderSide(color: dark ? Colors.white.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.30)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // ── Legal text ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Center(
                    child: LegalTextBlock(
                      onTerms: () => launchUrl(Uri.parse(_termsUrl), mode: LaunchMode.externalApplication),
                      onPrivacy: () => launchUrl(Uri.parse(_privacyUrl), mode: LaunchMode.externalApplication),
                    ),
                  ),
                ),
                // ── Conditional link ──
                if (widget.isOnboarding)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l.authBack,
                          style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black54, fontSize: 13),
                        ),
                      ),
                    ),
                  )
                else if (widget.onSwitchToLogin != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: TextButton(
                        onPressed: widget.onSwitchToLogin,
                        child: RichText(
                          text: TextSpan(
                            text: l.authHaveAccount,
                            style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black54, fontSize: 13),
                            children: [
                              TextSpan(
                                text: l.authLoginLink,
                                style: TextStyle(
                                  color: PremiumColors.primaryAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
