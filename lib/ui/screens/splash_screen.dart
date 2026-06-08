import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  final bool autoNavigate;
  const SplashScreen({super.key, this.autoNavigate = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late Animation<Color?> _bgAnim;
  bool _phase2 = false;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bgAnim = ColorTween(
      begin: PremiumColors.splashBlue,
      end: PremiumColors.deepBackground,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    // Phase 1: 1 segundo estático
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _phase2 = true);
      _bgCtrl.forward();
      // Esperar animación + servicios
      Future.delayed(const Duration(milliseconds: 1200), _navigateToWelcome);
    });
  }

  void _navigateToWelcome() {
    if (!mounted) return;
    if (!widget.autoNavigate) return;
    context.goNamed('welcome');
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _bgAnim,
      builder: (context, _) => Scaffold(
        backgroundColor: _phase2
            ? (dark ? _bgAnim.value ?? PremiumColors.deepBackground : PremiumColors.lightBg)
            : PremiumColors.splashBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.splashTitle,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: dark ? Colors.white.withValues(alpha: _phase2 ? 0.9 : 1.0) : Colors.black87,
                  letterSpacing: 6,
                ),
              ),
              if (_phase2)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        dark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}