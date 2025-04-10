import 'package:aitapp/application/state/tab_button_provider.dart';
import 'package:aitapp/presentation/screens/class_timetable.dart';
import 'package:aitapp/presentation/screens/notices.dart';
import 'package:aitapp/presentation/screens/schedule.dart';
import 'package:aitapp/presentation/screens/timetable_screen.dart';
import 'package:aitapp/presentation/wighets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabScreen extends HookConsumerWidget {
  const TabScreen({super.key});
  static const currentPages = [
    NoticeScreen(),
    ScheduleScreen(),
    ClassTimeTableScreen(),
    TimeTableScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = useState(0);
    return Scaffold(
      drawer: const MainDrawer(),
      body: SafeArea(child: currentPages[currentPageIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'お知らせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '予定',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '時間割',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: '時刻表',
          ),
        ],
        onTap: (index) {
          if (currentPageIndex.value == index) {
            ref.read(tabButtonProvider.notifier).state =
                !ref.read(tabButtonProvider);
          } else {
            currentPageIndex.value = index;
          }
        },
        currentIndex: currentPageIndex.value,
        selectedFontSize: 10,
        unselectedFontSize: 10,
      ),
    );
  }
}
