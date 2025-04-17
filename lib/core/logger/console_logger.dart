import 'package:flutter/foundation.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';

class ConsoleLogger implements AppLogger {
  @override
  void d(String message) {
    if (kDebugMode) {
      debugPrint('🐾️[DEBUG] $message');
    }
  }

  @override
  void i(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️[INFO] $message');
    }
  }

  @override
  void w(String message) {
    if (kDebugMode) debugPrint('⚠️[WARN] $message');
  }

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('🚨 $message');
      if (error != null) debugPrint('🔻 $error');
      if (stackTrace != null) debugPrint('$stackTrace');
    }
  }
}
