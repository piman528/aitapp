import 'package:aitapp/const.dart';
import 'package:flutter/material.dart';

class TimeTableDetailScreen extends StatelessWidget {
  const TimeTableDetailScreen({
    super.key,
    required this.vehicle,
    required this.destination,
  });
  final String vehicle;
  final String destination;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final todayDaiya = dayDaiya['${now.year}-${now.month}-${now.day}'];
    int? initialValue;
    switch (todayDaiya) {
      case 'A':
        initialValue = 0;
      case 'B':
        initialValue = 1;
      case 'C':
        initialValue = 2;
    }
    return DefaultTabController(
      initialIndex: initialValue ?? 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            vehicleName[vehicle]! + destinationName[destination]!,
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: todayDaiya == 'A' ? 'A (今日)' : 'A'),
              Tab(text: todayDaiya == 'B' ? 'B (今日)' : 'B'),
              Tab(text: todayDaiya == 'C' ? 'C (今日)' : 'C'),
            ],
          ),
        ),
        body: TabBarView(
          children: ['A', 'B', 'C']
              .map(
                (daiya) => DaiyaDetail(
                  daiyaA: daiya,
                  destination: destination,
                  vehicle: vehicle,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class DaiyaDetail extends StatelessWidget {
  const DaiyaDetail({
    super.key,
    required this.vehicle,
    required this.destination,
    required this.daiyaA,
  });
  final String vehicle;
  final String destination;
  final String daiyaA;

  @override
  Widget build(BuildContext context) {
    final daiyas = daiya[vehicle]![destination]![daiyaA]!;
    return ListView(
      children: [
        for (final hour in daiyas.keys) ...{
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$hour時',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 6,
            children: [
              for (final minutes in daiyas[hour]!) ...{
                Center(
                  child: Text(
                    '$minutes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              },
            ],
          ),
          const Divider(),
        },
      ],
    );
  }
}
