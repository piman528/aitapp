import 'package:aitapp/const.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/syllabus_list.dart';
import 'package:flutter/material.dart';

class SyllabusFilterScreen extends StatefulWidget {
  const SyllabusFilterScreen({
    super.key,
    required this.dayOfWeek,
    required this.classPeriod,
    this.teacher,
  });

  final DayOfWeek dayOfWeek;
  final int classPeriod;
  final String? teacher;

  @override
  State<SyllabusFilterScreen> createState() => _SyllabusSearchScreenState();
}

class _SyllabusSearchScreenState extends State<SyllabusFilterScreen> {
  final controller = TextEditingController();
  String filter = '';

  void _setFilterValue() {
    setState(() {
      filter = controller.text;
    });
  }

  @override
  void initState() {
    controller
      ..addListener(_setFilterValue)
      ..text = widget.teacher ?? '';
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${dayOfWeekToString[widget.dayOfWeek]} ${widget.classPeriod}限から検索',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: controller,
            hintText: '教授名、授業名で検索',
          ),
          SyllabusList(
            classPeriod: widget.classPeriod,
            dayOfWeek: widget.dayOfWeek,
            filterText: filter,
          ),
        ],
      ),
    );
  }
}
