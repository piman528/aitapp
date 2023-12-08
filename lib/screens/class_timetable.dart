import 'package:aitapp/wighets/class_timetable_item.dart';
import 'package:flutter/material.dart';

class ClassTimeTableScreen extends StatelessWidget {
  const ClassTimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '時間割',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            // color: Colors.grey,
            height: 60,
            child: Row(),
          ),
          Expanded(
            child: ListView(
              children: const [
                TimeTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
