import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../services/app_logger.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._() : _logger = AppLogger();
  final AppLogger _logger;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'chest_reminder';
  static const String _channelName = 'Recordatorio diario';
  static const String _channelDesc = 'Recordatorio para abrir tu cofre diario en SAGEN';
  static const int _reminderId = 2000;

  static const String _retentionChannelId = 'streak_retention';
  static const String _retentionChannelName = 'Retenci\u00f3n de racha';
  static const String _retentionChannelDesc = 'Alertas para mantener tu racha activa en SAGEN';
  static const int _streakReminderId = 2001;

  Future<void> init() async {
    if (_initialized) return;
    try {
      tz_data.initializeTimeZones();
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: androidSettings);
      await _plugin.initialize(settings);
      _initialized = true;
      _logger.info('NotificationService initialized');
    } catch (e) {
      _logger.error('NotificationService init failed', e);
    }
  }

  Future<void> scheduleChestReminder() async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(_reminderId);
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );
      const details = NotificationDetails(android: androidDetails);
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      await _plugin.zonedSchedule(
        _reminderId,
        '¡Tu cofre diario te espera!',
        'No olvides reclamar tus gemas gratis en SAGEN. Abre la app y toca el cofre.',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      _logger.info('Daily chest reminder scheduled at 20:00');
    } catch (e) {
      _logger.error('scheduleChestReminder failed', e);
    }
  }

  Future<void> scheduleStreakReminder(int currentStreak) async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(_streakReminderId);
      final now = tz.TZDateTime.now(tz.local);
      final scheduledDate = now.add(const Duration(hours: 24));

      String title;
      String body;
      if (currentStreak > 0) {
        title = 'Tu fuego se est\u00e1 apagando';
        body = 'Est\u00e1s a punto de perder tu racha de $currentStreak d\u00edas. Entra ahora y defiende tu rango.';
      } else {
        title = 'El Coliseo te espera';
        body = 'Tu pr\u00f3xima lecci\u00f3n de ciberseguridad est\u00e1 lista. \u00bfAceptas el desaf\u00edo?';
      }

      const androidDetails = AndroidNotificationDetails(
        _retentionChannelId,
        _retentionChannelName,
        channelDescription: _retentionChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const details = NotificationDetails(android: androidDetails);
      await _plugin.zonedSchedule(
        _streakReminderId,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      _logger.info('Streak reminder scheduled for 24h from now');
    } catch (e) {
      _logger.error('scheduleStreakReminder failed', e);
    }
  }

  Future<void> cancelStreakReminder() async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(_streakReminderId);
    } catch (e) {
      _logger.error('cancelStreakReminder failed', e);
    }
  }

  Future<void> cancelAll() async {
    if (!_initialized) return;
    try {
      await _plugin.cancelAll();
    } catch (e) {
      _logger.error('cancelAll failed', e);
    }
  }
}