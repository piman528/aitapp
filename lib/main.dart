import 'package:aitapp/classTimeTable.dart';
import 'package:aitapp/noticeList.dart';
import 'package:aitapp/busTimeTable.dart';
import 'package:aitapp/syllabusSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

main() {
  // スコープ
  const scope = ProviderScope(child: MyApp());
  runApp(scope);
}

// プロバイダー
final indexProvider = StateProvider((ref) {
  // 変化させたいデータ
  return 0;
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    // アイテム
    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.event), label: 'お知らせ'),
      BottomNavigationBarItem(icon: Icon(Icons.article), label: '時間割'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'シラバス検索'),
      BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: '時刻表'),
    ];

    // バー作成
    final bar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: index,
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

    // ページ一覧
    const pages = [
      noticeList(),
      classTimeTable(),
      syllabusSearch(),
      busTimeTable(),
    ];

    // ui組み立て
    return MaterialApp(
      // theme: ThemeData.dark(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.white))),
      home: Scaffold(
        body: pages[index],
        bottomNavigationBar: bar,
      ),
    );
  }
}
