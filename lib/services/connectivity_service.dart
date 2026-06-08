import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._();
  final _online = ValueNotifier<bool>(true);
  ValueNotifier<bool> get online => _online;
  bool _running = false;

  ConnectivityService._();

  void start() {
    if (_running) return;
    _running = true;
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _online.value = results.any((r) => r != ConnectivityResult.none);
  }

  void stop() {
    _running = false;
  }

  void dispose() {
    _running = false;
    _online.dispose();
  }

  void onAppResume() {
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _online.value = results.any((r) => r != ConnectivityResult.none);
  }
}
