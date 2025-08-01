import 'package:logger/logger.dart';

// Create a singleton Logger instance that can be accessed globally
class LoggerService {

  // Private constructor, only invoked once
  LoggerService._internal()
      : _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of stack trace lines to show for normal logs
      errorMethodCount: 2, // Number of stack trace lines to show for errors
      lineLength: 120, // Width of the output
      colors: true, // Enable colors
      printEmojis: true, // Enable emojis
      printTime: true, // Enable timestamp
    ),
  );
  // Private static instance of LoggerService
  static final LoggerService _instance = LoggerService._internal();

  // Logger instance with custom settings
  final Logger _logger;

  // Expose the singleton instance via a static getter
  static LoggerService get instance => _instance;

  // Expose the logger instance
  Logger get logger => _logger;

  // Helper methods for logging
  static void logInfo(String message) {
    instance._logger.i(message);
  }

  static void logWarning(String message) {
    instance._logger.w(message);
  }

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    instance._logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void logDebug(String message) {
    instance._logger.d(message);
  }

  static void logTrace(String message) {
    instance._logger.t(message);
  }

  static void logFatal(String message) {
    instance._logger.f(message);
  }
}
