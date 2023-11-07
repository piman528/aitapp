import 'package:aitapp/const.dart';
import 'package:flutter/material.dart';

class ClassTime extends StatelessWidget {
  const ClassTime({
    super.key,
    required this.start,
    required this.end,
    required this.number,
  });
  final String start;
  final String end;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: Measure.p_a2,
      // padding: EdgeInsets.all(5),
      alignment: Alignment.centerLeft,
      // color: const Color.fromARGB(255, 223, 223, 223),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            start,
            style: const TextStyle(fontSize: 12),
          ),
          Container(
            alignment: Alignment.center,
            margin: Measure.p_a8,
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.grey,
              color: Color.fromARGB(255, 236, 236, 236),
            ),
            child: Text('$number'),
          ),
          Text(
            end,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class TimeBar extends StatelessWidget {
  const TimeBar({super.key});

  @override
  Widget build(BuildContext context) {
    final spaceGridContainer = Container(
      alignment: Alignment.centerLeft,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(4),
      //   color: Color.fromARGB(255, 108, 108, 108),
      // ),
      margin: Measure.p_a2,
      height: 35,
    );
    return Column(
      children: [
        spaceGridContainer,
        const ClassTime(
          start: ClassPeriod.first_period_start,
          end: ClassPeriod.first_period_end,
          number: 1,
        ),
        const ClassTime(
          start: ClassPeriod.second_period_start,
          end: ClassPeriod.second_period_end,
          number: 2,
        ),
        const ClassTime(
          start: ClassPeriod.third_period_start,
          end: ClassPeriod.third_period_end,
          number: 3,
        ),
        const ClassTime(
          start: ClassPeriod.fourth_period_start,
          end: ClassPeriod.first_period_end,
          number: 4,
        ),
        const ClassTime(
          start: ClassPeriod.fifth_period_start,
          end: ClassPeriod.fifth_period_end,
          number: 5,
        ),
        const ClassTime(
          start: ClassPeriod.sixth_period_start,
          end: ClassPeriod.sixth_period_end,
          number: 6,
        ),
      ],
    );
  }
}

class WeekGridContainer extends StatelessWidget {
  const WeekGridContainer({super.key, required this.dayofweek});
  final String dayofweek;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromARGB(255, 236, 236, 236),
      ),
      margin: Measure.p_a2,
      height: 35,
      child: Text(dayofweek),
    );
  }
}

class ClassGridContainer extends StatelessWidget {
  const ClassGridContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('こんにちは');
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Measure.br_6,
          color: Color.fromARGB(255, 236, 236, 236),
        ),
        margin: Measure.p_a2,
        height: 80,
        // width: 170,
        // color: const Color.fromARGB(255, 223, 223, 223),
      ),
    );
  }
}

class DayClassGrid extends StatelessWidget {
  const DayClassGrid({super.key, required this.dayofweek});
  final String dayofweek;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WeekGridContainer(dayofweek: dayofweek),
          const ClassGridContainer(),
          const ClassGridContainer(),
          const ClassGridContainer(),
          const ClassGridContainer(),
          const ClassGridContainer(),
          const ClassGridContainer(),
        ],
      ),
    );
  }
}

class WeekClassGrid extends StatelessWidget {
  const WeekClassGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(15),
      // color: Colors.blue,
      child: Row(
        children: [
          for (final element in ClassPeriod.OneWeek) ...{
            DayClassGrid(dayofweek: element),
          },
        ],
      ),
    );
  }
}

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Measure.p_a4,
      child: const Row(
        children: [TimeBar(), Expanded(child: WeekClassGrid())],
      ),
    );
  }
}
