import 'package:aitapp/wighet/ClassTimeTableWidget.dart';
import 'package:flutter/material.dart';

class classTimeTable extends StatelessWidget {
  const classTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      children: const [TimeTable()],
    );
    final semSelector = Container(
      // color: Colors.grey,
      height: 60,
      child: const Row(),
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
