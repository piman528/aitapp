import 'package:aitapp/const.dart';
import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/get_syllabus.dart';
import 'package:aitapp/wighets/syllabus_item.dart';
import 'package:flutter/material.dart';

class SyllabusList extends StatelessWidget {
  SyllabusList({
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
  final getSyllabus = GetSyllabus();

  Future<List<ClassSyllabus>> _syllabusList() async {
    await getSyllabus.create();
    final syllabusList =
        await getSyllabus.getSyllabusList(dayOfWeek, classPeriod, searchText);
    return syllabusList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _syllabusList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ClassSyllabus>> snapshot) {
        if (snapshot.hasData) {
          late final List<ClassSyllabus> result;
          if (filterText != null) {
            result = snapshot.data!
                .where(
                  (syllabus) =>
                      syllabus.teacher.toLowerCase().contains(filterText!) ||
                      syllabus.subject.toLowerCase().contains(filterText!),
                )
                .toList();
          } else {
            result = snapshot.data!;
          }
          return Expanded(
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (c, i) => SyllabusItem(
                syllabus: result[i],
                getSyllabus: getSyllabus,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('データが存在しません');
        } else {
          return const Expanded(
            child: Center(
              child: SizedBox(
                height: 25, //指定
                width: 25, //指定
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
