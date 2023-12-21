import 'package:aitapp/wighets/class_timetable_item.dart';
import 'package:flutter/material.dart';

class ClassTimeTableScreen extends StatelessWidget {
  const ClassTimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 60,
          child: Row(),
        ),
        Expanded(
          child: TimeTable(),
        ),
      ],
    );
  }
}
