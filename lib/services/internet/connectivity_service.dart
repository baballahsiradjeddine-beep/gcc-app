import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final internetConnectionCheckerProvider = StreamProvider.autoDispose<bool>((ref) {
  final connectivityService = ref.watch(connectivityProvider);
  return connectivityService.onConnectivityChanged;
});

final internetConnectionProvider = Provider(
  (ref) => InternetConnection.createInstance(),
);

final connectivityProvider = Provider<ConnectivityService>((ref) {
  final internetConnectionChecker = ref.watch(internetConnectionProvider);
  final service = ConnectivityService(internetConnectionChecker);

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

class ConnectivityService {
  final InternetConnection _internetConnectionChecker;
  late final StreamController<bool> _controller;
  late final StreamSubscription<InternetStatus> _subscription;

  ConnectivityService(this._internetConnectionChecker) {
    _controller = StreamController<bool>();
    _subscription = _internetConnectionChecker.onStatusChange.listen((status) {
      _controller.add(status == InternetStatus.connected);
    });
  }

  Future<bool> get isConnected async {
    final status = await _internetConnectionChecker.internetStatus;
    return status == InternetStatus.connected;
  }

  Stream<bool> get onConnectivityChanged => _controller.stream;

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}