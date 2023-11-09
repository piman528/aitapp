import 'package:aitapp/tab/vehicle_time_table.dart';
import 'package:aitapp/tab/class_time_table.dart';
import 'package:aitapp/tab/notice_list.dart';
import 'package:aitapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// プロバイダー
final indexProvider = StateProvider((ref) {
  // 変化させたいデータ
  return 0;
});

class MainTab extends ConsumerWidget {
  const MainTab({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    // アイテム
    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.event), label: 'お知らせ'),
      BottomNavigationBarItem(icon: Icon(Icons.article), label: '時間割'),
      // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'シラバス検索'),
      BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: '時刻表'),
    ];
    // バー作成
    final bar = Container(
      // height: 50,
      child: BottomNavigationBar(
        iconSize: 20,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: items,
        // backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (index) {
          ref.read(indexProvider.notifier).state = index;
        },
      ),
    );
    // ページ一覧
    const pages = [
      NoticeList(),
      ClassTimeTable(),
      // SyllabusSearch(),
      BusTimeTable(),
    ];

    // ui組み立て
    return MaterialApp(
      // theme: ThemeData.dark(),
      theme: buildThemeLight(),
      // darkTheme: buildThemeDark(),
      home: Scaffold(
        body: pages[index],
        bottomNavigationBar: bar,
      ),
    );
  }
}
