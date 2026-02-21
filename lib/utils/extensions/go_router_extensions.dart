import 'package:go_router/go_router.dart';
import 'package:tayssir/debug/app_logger.dart';

extension GoRouterExtension on GoRouter {
  String get _currentRoute =>
      routerDelegate.currentConfiguration.matches.last.matchedLocation;
  void popUntil(String routeName) {
    AppLogger.logDebug('current route: $_currentRoute');
    while (_currentRoute != routeName) {
      pop();
    }
  }
}
