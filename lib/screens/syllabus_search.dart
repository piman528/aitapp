import 'package:aitapp/const.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/syllabus_list.dart';
import 'package:flutter/material.dart';

class SyllabusSearchScreen extends StatelessWidget {
  const SyllabusSearchScreen({
    super.key,
    required this.dayOfWeek,
    required this.classPeriod,
  });

  final DayOfWeek dayOfWeek;
  final int classPeriod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '${dayOfWeekToString[dayOfWeek]} $classPeriod限から検索',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: TextEditingController(),
            hintText: '教授名、授業名で検索',
          ),
          SyllabusList(
            classPeriod: classPeriod,
            dayOfWeek: dayOfWeek,
          ),
        ],
      ),
    );
  }
}
