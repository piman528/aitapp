import 'package:aitapp/screens/class_timetable.dart';
import 'package:aitapp/screens/notices.dart';
import 'package:aitapp/screens/vehicle_timetable.dart';
import 'package:aitapp/wighets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});
  static const appBarTitle = [
    'お知らせ',
    '時間割',
    '時刻表',
  ];
  static const currentPages = [
    NoticeScreen(),
    ClassTimeTableScreen(),
    TimeTableScreen(),
  ];
  static const destinations = [
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
  ];
  @override
  Widget build(BuildContext context) {
    final currentPageIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(appBarTitle[currentPageIndex.value]),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: currentPages[currentPageIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex.value,
        destinations: destinations,
        onDestinationSelected: (index) {
          currentPageIndex.value = index;
        },
      ),
    );
  }
}
