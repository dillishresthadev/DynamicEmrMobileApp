import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityCheck {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class ConnectivityCheckImpl implements ConnectivityCheck {
  final Connectivity _connectivity;

  // Constructor
  ConnectivityCheckImpl({required Connectivity connectivity})
    : _connectivity = connectivity;

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains((ConnectivityResult.ethernet));
    } catch (e) {
      log('Error checking connectivity: $e');
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map((result) {
          return result.contains(ConnectivityResult.mobile) ||
              result.contains(ConnectivityResult.wifi) ||
              result.contains((ConnectivityResult.ethernet));
        })
        .handleError((e) {
          log('Error in connectivity stream: $e');
          return false;
        });
  }
}
