import 'package:aitapp/screens/class_timetable.dart';
import 'package:aitapp/screens/notices.dart';
import 'package:aitapp/screens/vehicle_timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});
  void initState() {
    //アプリ起動時に一度だけ実行される
    // logIn();
  }

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _currentPageIndex = 0;
  List<Widget> currentPages = [
    const NoticeScreen(),
    const ClassTimeTableScreen(),
    const TimeTableScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    // final asyncValue = ref.watch(classTimeTableProvider);
    // if (asyncValue.isLoading) {
    //   ref.read(classTimeTableProvider.notifier).fetchData();
    // }
    return Scaffold(
      body: currentPages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: _currentPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'お知らせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '時間割',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: '時刻表',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
