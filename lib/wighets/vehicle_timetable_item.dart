import 'dart:async';

import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/next_departure.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTableCard extends StatelessWidget {
  const TimeTableCard({
    super.key,
    required this.vehicle,
    required this.destination,
  });
  final String vehicle;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicleName[vehicle]! + destinationName[destination]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '時刻表を見る',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView(
              children: [
                TimeCard(
                  vehicle: vehicle,
                  destination: destination,
                  order: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                TimeCard(
                  vehicle: vehicle,
                  destination: destination,
                  order: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                TimeCard(
                  vehicle: vehicle,
                  destination: destination,
                  order: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeCard extends StatefulWidget {
  const TimeCard({
    super.key,
    required this.vehicle,
    required this.destination,
    required this.order,
  });
  final String vehicle;
  final String destination;
  final int order;

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  late DateTime _time;
  late Timer _timer;

  @override
  void initState() {
    _time = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _time = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextDepartureTime = NextDeparture(
      vehicle: widget.vehicle,
      destination: widget.destination,
      order: widget.order,
    ).searchNextDeparture();
    if (nextDepartureTime != null) {
      final remainTime = nextDepartureTime.difference(_time);
      final f = DateFormat('HH:mm');
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).canvasColor,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
          color: Theme.of(context).hoverColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'あと${remainTime.inMinutes % 60}分${remainTime.inSeconds % 60}秒',
                  style: const TextStyle(
                    // color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Text(
              f.format(nextDepartureTime),
              style: const TextStyle(
                // color: Colors.black,
                fontSize: 48,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
