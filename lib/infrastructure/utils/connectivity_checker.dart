import 'package:wallify/infrastructure/utils/general_utils.dart';

abstract class ConnectivityChecker {
  Future<bool> isInternetAvailable();
}

class ConnectivityCheckerImpl implements ConnectivityChecker {
  final GeneralUtils _generalUtils;

  ConnectivityCheckerImpl({GeneralUtils? generalUtils})
      : _generalUtils = generalUtils ?? GeneralUtils();

  @override
  Future<bool> isInternetAvailable() {
    return _generalUtils.isInternetAvailable();
  }
}