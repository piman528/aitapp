import 'package:aitapp/screens/class_timetable.dart';
import 'package:aitapp/screens/notices.dart';
import 'package:aitapp/screens/vehicle_timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

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
  List<String> appBarTitle = [
    'お知らせ',
    '時間割',
    '時刻表',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle[_currentPageIndex]),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: currentPages[_currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
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
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
