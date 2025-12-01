import 'package:logger/logger.dart';

class LoggerService {
  LoggerService._internal()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 2,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: true,
        ),
      );

  static final LoggerService _instance = LoggerService._internal();
  static LoggerService get instance => _instance;

  final Logger _logger;

  // INSTANCE METHODS ✅
  void logInfo(String message) => _logger.i(message);
  void logWarning(String message) => _logger.w(message);
  void logError(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  void logDebug(String message) => _logger.d(message);
  void logTrace(String message) => _logger.t(message);
  void logFatal(String message) => _logger.f(message);
}
