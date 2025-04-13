abstract class AppLogger {
  void d(String message);
  void i(String message);
  void e(String message, [Object? error, StackTrace? stackTrace]);
}