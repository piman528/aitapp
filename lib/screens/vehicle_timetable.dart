import 'package:aitapp/wighets/vehicle_timetable_item.dart';
import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            '時刻表',
            // style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'シャトルバス',
              ),
              Tab(
                text: 'リニモ',
              ),
            ],
            // labelColor: Colors.black,
          ),
        ),
        body: const TabBarView(
          children: [
            Column(
              children: [
                TimeTableCard(
                  vehicle: 'bus',
                  destination: 'toAIT',
                ),
                TimeTableCard(
                  vehicle: 'bus',
                  destination: 'toYakusa',
                ),
              ],
            ),
            Column(
              children: [
                TimeTableCard(
                  vehicle: 'linimo',
                  destination: 'toYakusa',
                ),
                TimeTableCard(
                  vehicle: 'linimo',
                  destination: 'toHujigaoka',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
