import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/services/sage_emotion_service.dart';
import 'package:sagen/ui/widgets/common/sage_emotion_widget.dart';

class RegistrationMethodsScreen extends StatefulWidget {
  final VoidCallback onEmail;
  final VoidCallback onGoogle;

  const RegistrationMethodsScreen({
    super.key,
    required this.onEmail,
    required this.onGoogle,
  });

  @override
  State<RegistrationMethodsScreen> createState() => _RegistrationMethodsScreenState();
}

class _RegistrationMethodsScreenState extends State<RegistrationMethodsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  Widget _build3DButton({
    required String label,
    Color? color,
    Color? borderColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF1E1E24),
          borderRadius: BorderRadius.circular(16),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
            left: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
            right: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
            bottom: BorderSide(
              color: borderColor ?? const Color(0xFF0A0A0C),
              width: 4,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Color(0xFF1E1E24),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8EE000)),
            minHeight: 12,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                l.regMethodTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -10 * _floatController.value),
                    child: child,
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                            blurRadius: 60,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 150, height: 150, child: SageEmotionWidget(emotion: SageEmotion.neutral)),
                  ],
                ),
              ),
              const Spacer(),
              _build3DButton(
                label: l.authGoogleButton,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.onGoogle();
                },
              ),
              const SizedBox(height: 16),
              _build3DButton(
                label: l.regEmailOption,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.onEmail();
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white38, fontSize: 13, height: 1.4),
                    children: [
                      TextSpan(text: l.legalRegisterAgree),
                      TextSpan(
                        text: l.legalTerms,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = HapticFeedback.lightImpact,
                      ),
                      TextSpan(text: l.legalAnd),
                      TextSpan(
                        text: l.legalPrivacy,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = HapticFeedback.lightImpact,
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
