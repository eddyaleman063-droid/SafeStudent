import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class _AppLoggerState {
  bool productionMode = false;
  void Function(Object, StackTrace)? crashReporter;
  final List<_LogEntry> recentErrors = [];
}

class AppLogger {
  static final _AppLoggerState _state = _AppLoggerState();
  static const int _maxRecentErrors = 50;

  AppLogger();

  void setProductionMode(bool enabled) {
    _state.productionMode = enabled;
  }

  void setCrashReporter(void Function(Object, StackTrace) reporter) {
    _state.crashReporter = reporter;
  }

  List<Map<String, dynamic>> get recentErrors =>
      _state.recentErrors.map((e) => {'time': e.time.toIso8601String(), 'message': e.message}).toList();

  void debug(String message) {
    if (!_state.productionMode) debugPrint('[SAGEN] $message');
  }

  void info(String message) {
    if (!_state.productionMode) debugPrint('[SAGEN] [INFO] $message');
  }

  void warning(String message) {
    if (!_state.productionMode) debugPrint('[SAGEN] [WARN] $message');
  }

  void error(String message, [Object? exception, StackTrace? stack]) {
    _state.recentErrors.add(_LogEntry(message, DateTime.now()));
    if (_state.recentErrors.length > _maxRecentErrors) _state.recentErrors.removeAt(0);

    debugPrint('[SAGEN] [ERROR] $message');
    if (exception != null) debugPrint('  Exception: $exception');
    if (stack != null) debugPrint('  Stack: $stack');
    if (exception != null && stack != null && _state.crashReporter != null) {
      _state.crashReporter!(exception, stack);
    }
  }

  void log(LogLevel level, String message, [Object? exception, StackTrace? stack]) {
    switch (level) {
      case LogLevel.debug: debug(message);
      case LogLevel.info: info(message);
      case LogLevel.warning: warning(message);
      case LogLevel.error: error(message, exception, stack);
    }
  }
}

class _LogEntry {
  final String message;
  final DateTime time;
  _LogEntry(this.message, this.time);
}
