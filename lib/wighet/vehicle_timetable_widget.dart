import 'package:aitapp/const.dart';
import 'package:aitapp/core/next_departure.dart';
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
      padding: Measure.p_a8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Vehicle.name[vehicle]! + Vehicle.destinationName[destination]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '時刻表を見る',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
    return Container(
      // padding: EdgeInsets.all(5),
      child: Column(
        children: [
          destinationTitle,
          for (int i = 0; i < 3; i++) ...{
            TimeCard(
              vehicle: vehicle,
              destination: destination,
              order: i,
            ),
            // if (TimeCard(
            //       vehicle: vehicle,
            //       destination: destination,
            //       order: i,
            //     ) ==
            //     SizedBox())
            //   {}
          }
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
        // width: 1000,
        // height: 100,
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        padding: Measure.p_a16,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 219, 219, 219),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
          color: Colors.white,
          borderRadius: Measure.br_8,
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
