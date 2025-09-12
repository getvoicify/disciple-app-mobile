import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final BuildContext globalContext = navigatorKey.currentContext!;

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: navigatorKey);

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: NotesRoute.page, initial: true),
    AutoRoute(page: NoteDetailsRoute.page),
    AutoRoute(page: NewNotesRoute.page),
  ];
}
