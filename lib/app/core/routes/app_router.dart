import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/core/routes/guard/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final BuildContext globalContext = navigatorKey.currentContext!;

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.keycloakService})
    : _authGuard = AuthGuard(keycloakService),
      super(navigatorKey: navigatorKey);

  final AuthGuard _authGuard;
  final KeycloakService keycloakService;

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeboardingRoute.page,
      initial: !keycloakService.isAuthenticated,
    ),
    AutoRoute(
      page: NotesRoute.page,
      guards: [_authGuard],
      initial: keycloakService.isAuthenticated,
    ),
    AutoRoute(page: NoteDetailsRoute.page, guards: [_authGuard]),
    AutoRoute(page: NewNotesRoute.page, guards: [_authGuard]),
  ];
}
