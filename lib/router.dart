import 'package:aitapp/app.dart';
import 'package:aitapp/tab/class_time_table.dart';
import 'package:aitapp/tab/notice_detail.dart';
import 'package:aitapp/tab/notice_tab.dart';
import 'package:aitapp/tab/syllabus_search.dart';
import 'package:aitapp/tab/vehicle_time_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationHelper {
  factory CustomNavigationHelper() {
    return _instance;
  }

  CustomNavigationHelper._internal() {
    final routes = [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: noticeTabNavigatorKey,
            routes: [
              GoRoute(
                path: noticeListPath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const NoticeTab(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: searchTabNavigatorKey,
            routes: [
              GoRoute(
                path: classTimeTablePath,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const ClassTimeTable(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: settingsTabNavigatorKey,
            routes: [
              GoRoute(
                path: vehicleTimeTablePath,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const BusTimeTable(),
                    state: state,
                  );
                },
              ),
            ],
          ),
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: BottomNavigationPage(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: noticeDetailPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const NoticeDetail(),
            state: state,
          );
        },
      ),
      GoRoute(
        // parentNavigatorKey: parentNavigatorKey,
        path: syllabusSearchPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const SyllabusSearch(),
            state: state,
          );
        },
      ),
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: noticeListPath,
      routes: routes,
    );
  }
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static CustomNavigationHelper get instance => _instance;

  static late final GoRouter router;

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> noticeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> searchTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsTabNavigatorKey =
      GlobalKey<NavigatorState>();

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  static const String signUpPath = '/signUp';
  static const String signInPath = '/signIn';
  static const String noticeDetailPath = '/noticeDetail';
  static const String syllabusSearchPath = '/syllabusSearchPath';

  static const String noticeListPath = '/noticeList';
  static const String vehicleTimeTablePath = '/vehicleTimeTable';
  static const String classTimeTablePath = '/classTimeTable';

  static Page<dynamic> getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
