import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/next_departure.dart';
import 'package:flutter/material.dart';

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
    final destinationTitle = Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            vehicleName[vehicle]! + destinationName[destination]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            '時刻表を見る',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
    return Expanded(
      child: Column(
        children: [
          destinationTitle,
          const SizedBox(
            height: 5,
          ),
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
    );
  }
}

class TimeCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final nextDepartureTime = NextDeparture(
      vehicle: vehicle,
      destination: destination,
      order: order,
    ).searchNextDeparture();
    if (nextDepartureTime != '') {
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'あと5:00',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            Text(
              nextDepartureTime,
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
