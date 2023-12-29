import 'package:aitapp/screens/class_timetable.dart';
import 'package:aitapp/screens/notices.dart';
import 'package:aitapp/screens/vehicle_timetable.dart';
import 'package:aitapp/wighets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = useState(0);
    final appBarTitle = [
      'お知らせ',
      '時間割',
      '時刻表',
    ];
    final currentPages = [
      const NoticeScreen(),
      const ClassTimeTableScreen(),
      const TimeTableScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle[currentPageIndex.value]),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: currentPages[currentPageIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex.value,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'お知らせ',
          ),
          NavigationDestination(
            icon: Icon(Icons.event),
            label: '時間割',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus),
            label: '時刻表',
          ),
        ],
        onDestinationSelected: (index) {
          currentPageIndex.value = index;
        },
      ),
    );
  }
}
