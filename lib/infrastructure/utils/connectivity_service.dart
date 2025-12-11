import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConnectivityService {
  // Create a singleton instance of the service
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  // Stream controller to broadcast connectivity changes
  final StreamController<List<ConnectivityResult>> _connectivityController =
      StreamController<List<ConnectivityResult>>.broadcast();

  Stream<List<ConnectivityResult>> get connectivityStream => _connectivityController.stream;

  Future<void> init() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error initializing connectivity: $e');
      }
      result = [ConnectivityResult.none];
    }

    _connectivityController.add(result);

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _connectivityController.add(result);
    });
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  void dispose() {
    _connectivityController.close();
  }
}
