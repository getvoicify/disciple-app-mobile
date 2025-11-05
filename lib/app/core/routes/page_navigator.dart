import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:disciple/app/core/routes/app_router.dart';

class PageNavigator {
  static final globalNavigatorKey = navigatorKey;

  static BuildContext get context => navigatorKey.currentContext!;

  static void _playHapticFeedback() => HapticFeedback.selectionClick();

  static Future<dynamic> pushRoute(
    PageRouteInfo<void> route, {
    bool withHapticFeedback = true,
  }) async {
    if (withHapticFeedback) _playHapticFeedback();
    return await context.pushRoute(route);
  }

  static Future<void> replace(
    PageRouteInfo<void> route, {
    bool withHapticFeedback = true,
  }) async {
    if (withHapticFeedback) _playHapticFeedback();
    await context.router.replaceAll([route]);
  }

  static void popUntil(
    String routeName, {
    Object? extra,
    bool withHapticFeedback = true,
  }) {
    if (withHapticFeedback) _playHapticFeedback();
    context.router.popUntilRouteWithPath(routeName);
  }

  static Future<void> pop([
    dynamic result,
    bool withHapticFeedback = true,
  ]) async {
    if (globalNavigatorKey.currentContext != null) {
      if (withHapticFeedback) _playHapticFeedback();
      globalNavigatorKey.currentContext!.router.pop(result);
    }
  }

  static Future<void> popToRoot({
    PageRouteInfo<dynamic>? route,
    bool withHapticFeedback = true,
  }) async {
    if (globalNavigatorKey.currentContext != null) {
      if (withHapticFeedback) _playHapticFeedback();
      return globalNavigatorKey.currentContext!.router.popUntil(
        (r) => r.settings.name == route?.routeName,
      );
    }
  }

  static bool get canPop => navigatorKey.currentState?.canPop() ?? false;
}
