import 'package:flutter/material.dart';

class classTimeTable extends StatelessWidget {
  const classTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    // 曜日表示
    final weekGridContainer = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color.fromARGB(255, 236, 236, 236),
      ),
      margin: const EdgeInsets.all(2),
      height: 40,
      child: const Text('月'),
    );
    // 左上
    final spaceGridContainer = Container(
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(4),
      //   color: const Color.fromARGB(255, 223, 223, 223),
      // ),
      margin: const EdgeInsets.all(2),
      height: 40,
    );
    // 時間表示
    final timeView = Container(
      height: 95,
      margin: const EdgeInsets.all(2),
      // padding: EdgeInsets.all(5),
      alignment: Alignment.bottomCenter,
      // color: const Color.fromARGB(255, 223, 223, 223),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '09:00',
            style: TextStyle(fontSize: 12),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(7),
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.grey,
              color: Color.fromARGB(255, 236, 236, 236),
            ),
            child: const Text('1'),
          ),
          const Text(
            '10:30',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
    // 授業
    final gridContainer = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color.fromARGB(255, 236, 236, 236),
      ),
      margin: const EdgeInsets.all(2),
      height: 95,
      // width: 170,
      // color: const Color.fromARGB(255, 223, 223, 223),
    );
    // 時間列
    final timeColumn = Column(
      children: [
        spaceGridContainer,
        timeView,
        timeView,
        timeView,
        timeView,
        timeView,
        timeView,
      ],
    );
    // 授業列
    final dayClassGrid = Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          weekGridContainer,
          gridContainer,
          gridContainer,
          gridContainer,
          gridContainer,
          gridContainer,
          gridContainer,
        ],
      ),
    );
    final weekClassGrid = Container(
      // padding: const EdgeInsets.all(15),
      // color: Colors.blue,
      child: Row(
        children: [
          dayClassGrid,
          dayClassGrid,
          dayClassGrid,
          dayClassGrid,
          dayClassGrid,
        ],
      ),
    );
    final timeTable = Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Row(
        children: [timeColumn, Expanded(child: weekClassGrid)],
      ),
    );
    final list = ListView(
      children: [timeTable],
    );
    final semSelector = Container(
      // color: Colors.grey,
      height: 90,
      child: Row(),
    );
    final tabScreen = Column(
      children: [semSelector, Expanded(child: list)],
    );

    return Scaffold(
      appBar: AppBar(
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
