import 'package:aitapp/app.dart';
import 'package:aitapp/notice_detail.dart';
import 'package:aitapp/syllabus_search.dart';
import 'package:aitapp/tab/notice_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

main() {
  // スコープ
  // const scope = ProviderScope(child: App());
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final router = GoRouter(initialLocation: '/maintab', routes: [
    GoRoute(
      path: '/maintab',
      builder: (context, state) => ProviderScope(
        child: MainTab(),
      ),
    ),
    GoRoute(
      path: '/notice',
      builder: (context, state) => NoticeList(),
    ),
    GoRoute(
      path: '/noticeDetail',
      builder: (context, state) => NoticeDetail(),
    ),
    GoRoute(
      path: '/syllabusSearch',
      builder: (context, state) => SyllabusSearch(),
    ),
  ]);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
