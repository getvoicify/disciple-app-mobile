import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final BuildContext globalContext = navigatorKey.currentContext!;

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: navigatorKey);

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeboardingRoute.page),
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(
      page: DashboardRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: BibleRoute.page),
        AutoRoute(page: CommunityRoute.page),
        AutoRoute(page: TodayRemindersRoute.page),
        AutoRoute(page: MoreRoute.page),
      ],
    ),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: NotesRoute.page),
    AutoRoute(page: NoteDetailsRoute.page),
    AutoRoute(page: NewNotesRoute.page),
    AutoRoute(page: BibleRoute.page),
    AutoRoute(page: DevotionalsRoute.page),
    AutoRoute(page: BookmarksRoute.page),
    AutoRoute(page: ChurchRoute.page),
    AutoRoute(page: CreateReminderRoute.page),
    AutoRoute(page: AllRemindersRoute.page),
  ];
}
