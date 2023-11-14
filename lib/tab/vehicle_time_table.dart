import 'package:aitapp/wighet/vehicle_timetable_widget.dart';
import 'package:flutter/material.dart';

class BusTimeTable extends StatelessWidget {
  const BusTimeTable({super.key});

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
            labelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: const [
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
            ListView(
              children: const [
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
