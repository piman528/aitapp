import 'package:aitapp/wighets/class_timetable_item.dart';
import 'package:flutter/material.dart';

enum Semester {
  early,
  late,
}

class ClassTimeTableScreen extends StatelessWidget {
  const ClassTimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // SizedBox(
        //   height: 60,
        // child: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Row(
        //     children: [
        //       DropdownButton(
        //         value: '前期',
        //         items: const [
        //           DropdownMenuItem(
        //             value: '前期',
        //             child: Text('前期'),
        //           ),
        //           DropdownMenuItem(
        //             value: '後期',
        //             child: Text('後期'),
        //           ),
        //         ],
        //         onChanged: (item) {},
        //       ),
        //     ],
        //   ),
        // ),
        // ),
        Expanded(
          child: TimeTable(),
        ),
      ],
    );
  }
}
