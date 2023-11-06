import 'package:flutter/material.dart';

class busTimeTable extends StatelessWidget {
  const busTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final time = Container(
      // width: 1000,
      // height: 100,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 219, 219, 219),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   '愛工大行',
              //   style: TextStyle(
              //     // color: Colors.black,
              //     fontSize: 16,
              //   ),
              // ),
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
            '13:00',
            style: TextStyle(
              // color: Colors.black,
              fontSize: 48,
            ),
          ),
        ],
      ),
    );
    final destination = Container(
      padding: const EdgeInsets.all(8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'シャトルバス(八草行)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // Text(
          //   'もっと見る',
          //   style: TextStyle(fontSize: 14),
          // ),
        ],
      ),
    );
    final timeTo = Container(
      // padding: EdgeInsets.all(5),
      child: Column(
        children: [
          destination,
          time,
          time,
          time,
        ],
      ),
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          // backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            '時刻表',
            // style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'シャトルバス',
              ),
              Tab(
                text: 'リニモ',
              ),
              // Tab(
              //   text: '時刻表',
              // ),
            ],
            labelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                timeTo,
                timeTo,
                // timeTo,
                // timeTo,
              ],
            ),
            ListView(
              children: [
                timeTo,
                timeTo,
                // timeTo,
                // timeTo,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
