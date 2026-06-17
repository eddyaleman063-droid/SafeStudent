import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/sage_emotion_service.dart';
import '../../widgets/common/sage_emotion_widget.dart';

class NotificationOptInScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback? onBack;

  const NotificationOptInScreen({
    super.key,
    required this.onContinue,
    this.onBack,
  });

  Future<void> _requestPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();
    final androidPlugin =
        plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  onPressed: onBack ?? () => Navigator.pop(context),
                ),
              ),
              const Spacer(flex: 2),
              const SizedBox(
                width: 120,
                height: 120,
                child: SageEmotionWidget(
                  emotion: SageEmotion.happy,
                  size: 120,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                '¿Te avisamos?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Activa las notificaciones para no perderte tu racha, '
                'recordatorios diarios y desafíos importantes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
              GestureDetector(
                onTap: () {
                  _requestPermission();
                  onContinue();
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryAccent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: PremiumColors.primaryDark.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'ACTIVAR NOTIFICACIONES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onContinue,
                child: Text(
                  'Ahora no',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}
