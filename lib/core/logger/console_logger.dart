import 'package:flutter/foundation.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';

class ConsoleLogger implements AppLogger {
  @override
  void d(String message) {
    if (kDebugMode) {
      debugPrint('🟢 $message');
    }
  }

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('❌ $message');
      if (error != null) debugPrint('🔻 $error');
      if (stackTrace != null) debugPrint('$stackTrace');
    }
  }
}
