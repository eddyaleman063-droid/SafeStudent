import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/config/app_transitions.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/widgets/common/ambient_background.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  String? _lastError;
  late final dynamic _oldHandler;

  @override
  void initState() {
    super.initState();
    _oldHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      final msg = details.exceptionAsString();
      if (_lastError != msg) {
        _lastError = msg;
        if (mounted) setState(() {});
      }
      _oldHandler?.call(details);
    };
  }

  @override
  void dispose() {
    FlutterError.onError = _oldHandler;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _lastError != null ? _ErrorFallback(message: _lastError!) : widget.child;
  }
}

class _ErrorFallback extends StatelessWidget {
  final String message;
  const _ErrorFallback({required this.message});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AmbientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 64,
                      color: PremiumColors.error.withValues(alpha: 0.7)),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(l.errorSomethingWrong,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: dark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 12),
                  Text(
                    l.errorUnexpected,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: dark ? Colors.white60 : Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          color: dark ? Colors.white30 : Colors.grey.shade500)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      AppTransitions.fade(const _AppRestarter()),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(l.errorRestartApp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PremiumColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppRestarter extends StatelessWidget {
  const _AppRestarter();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
