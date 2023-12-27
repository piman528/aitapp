import 'dart:io';

import 'package:aitapp/const.dart';
import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/get_syllabus.dart';
import 'package:aitapp/wighets/syllabus_item.dart';
import 'package:flutter/material.dart';

class SyllabusSearchList extends StatefulWidget {
  const SyllabusSearchList({
    super.key,
    this.dayOfWeek,
    this.classPeriod,
    this.filterText,
    this.searchText,
  });
  final DayOfWeek? dayOfWeek;
  final int? classPeriod;
  final String? filterText;
  final String? searchText;

  @override
  State<SyllabusSearchList> createState() => _SyllabusListState();
}

class _SyllabusListState extends State<SyllabusSearchList> {
  final getSyllabus = GetSyllabus();
  List<ClassSyllabus>? syllabusList;
  Widget content = const Expanded(
    child: Center(
      child: SizedBox(
        height: 25, //指定
        width: 25, //指定
        child: CircularProgressIndicator(),
      ),
    ),
  );

  Future<void> _load() async {
    try {
      await getSyllabus.create();
      final list = await getSyllabus.getSyllabusList(
        widget.dayOfWeek,
        widget.classPeriod,
        widget.searchText,
      );
      setState(() {
        syllabusList = list;
      });
    } on SocketException {
      setState(() {
        content = const Center(
          child: Text('インターネットに接続できません'),
        );
      });
    } on Exception catch (err) {
      setState(() {
        content = Center(
          child: Text(err.toString()),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant SyllabusSearchList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      syllabusList = null;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (syllabusList != null) {
      return Expanded(
        child: ListView.builder(
          itemCount: syllabusList!.length,
          itemBuilder: (c, i) => SyllabusItem(
            syllabus: syllabusList![i],
            getSyllabus: getSyllabus,
          ),
        ),
      );
    }
    return content;
  }
}
