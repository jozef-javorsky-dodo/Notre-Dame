// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:notredame/data/services/analytics_service.dart';
import 'package:notredame/data/services/navigation_history_observer.dart';
import 'package:notredame/data/services/remote_config_service.dart';
import 'package:notredame/domain/constants/router_paths.dart';
import 'package:notredame/locator.dart';

//SERVICE

//CONSTANT

//OTHERS

/// Navigation service who doesn't use the BuildContext which allow us to call it from anywhere.
class NavigationService {
  static const String tag = "NavigationService";

  final RemoteConfigService remoteConfigService = locator<RemoteConfigService>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Will be used to report event and error.
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  /// Will be used to remove duplicate routes.
  final NavigationHistoryObserver _navigationHistoryObserver = NavigationHistoryObserver();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Pop the last route of the navigator if possible
  bool pop() {
    final currentState = _navigatorKey.currentState;

    if (currentState != null && currentState.canPop()) {
      currentState.pop();
      return true;
    }
    return false;
  }

  /// Push a named route [routeName] onto the navigator.
  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    final currentState = _navigatorKey.currentState;

    if (currentState == null) {
      _analyticsService.logError(tag, "Navigator state is null");
      return Future.error("Navigator state is null");
    }

    if (remoteConfigService.outage) {
      return currentState.pushNamedAndRemoveUntil(RouterPaths.serviceOutage, (route) => false);
    }
    return currentState.pushNamed(routeName, arguments: arguments);
  }

  /// Push a named route [routeName] onto the navigator
  /// and remove existing routes with the same [routeName]
  Future<dynamic> pushNamedAndRemoveDuplicates(String routeName, {dynamic arguments}) {
    final currentState = _navigatorKey.currentState;

    if (currentState == null) {
      _analyticsService.logError(tag, "Navigator state is null");
      return Future.error("Navigator state is null");
    }

    if (remoteConfigService.outage) {
      return currentState.pushNamedAndRemoveUntil(RouterPaths.serviceOutage, (route) => false);
    }

    final route = _navigationHistoryObserver.history.where((r) => r.settings.name == routeName).firstOrNull;

    if (route != null) {
      currentState.removeRoute(route);
    }
    return currentState.pushNamed(routeName, arguments: arguments);
  }

  /// Replace the current route of the navigator by pushing the route named
  /// [routeName] and then delete the stack of previous routes
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, [
    String removeUntilRouteNamed = RouterPaths.dashboard,
    Object? arguments,
  ]) {
    final currentState = _navigatorKey.currentState;
    if (currentState == null) {
      _analyticsService.logError(tag, "Navigator state is null");
      return Future.error("Navigator state is null");
    }

    if (remoteConfigService.outage) {
      return currentState.pushNamedAndRemoveUntil(RouterPaths.serviceOutage, (route) => false);
    }
    return currentState.pushNamedAndRemoveUntil(
      routeName,
      ModalRoute.withName(removeUntilRouteNamed),
      arguments: arguments,
    );
  }
}
