import 'package:aitapp/wighet/class_timetable_widget.dart';
import 'package:flutter/material.dart';

class ClassTimeTable extends StatelessWidget {
  const ClassTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      children: const [TimeTable()],
    );
    const semSelector = SizedBox(
      // color: Colors.grey,
      height: 60,
      child: Row(),
    );
    final tabScreen = Column(
      children: [semSelector, Expanded(child: list)],
    );

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
      body: tabScreen,
    );
  }
}
