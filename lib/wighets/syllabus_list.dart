import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/infrastructure/syllabus_search.dart';
import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/wighets/syllabus_item.dart';
import 'package:flutter/material.dart';

class SyllabusList extends StatelessWidget {
  const SyllabusList({
    super.key,
    required this.dayOfWeek,
    required this.classPeriod,
  });
  final DayOfWeek dayOfWeek;
  final int classPeriod;

  Future<List<ClassSyllabus>> _syllabusList() async {
    final jSessionId = await getSyllabusSearchBody();
    final body = await getSyllabusListBody(
      1,
      2,
      dayOfWeekToInt[dayOfWeek]!,
      classPeriod,
      '02',
      jSessionId,
    );
    final syllabusList = parseSyllabusList(body);
    return syllabusList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _syllabusList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ClassSyllabus>> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (c, i) => SyllabusItem(
                syllabus: snapshot.data![i],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('データが存在しません');
        } else {
          return const Center(
            child: SizedBox(
              height: 25, //指定
              width: 25, //指定
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
