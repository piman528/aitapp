import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/infrastructure/syllabus_search.dart';
import 'package:aitapp/models/class_syllabus.dart';

class GetSyllabus {
  late String jSessionId;
  Future<void> create() async {
    jSessionId = await getSyllabusSessionId();
  }

  Future<List<ClassSyllabus>> getSyllabusList(
    DayOfWeek? dayOfWeek,
    int? classPeriod,
    String? searchWord,
  ) async {
    final body = await getSyllabusListBody(
      1,
      2,
      dayOfWeekToInt[dayOfWeek],
      classPeriod,
      '02',
      jSessionId,
      searchWord,
    );
    return parseSyllabusList(body);
  }

  Future<ClassSyllabusDetail> getSyllabusDetail(ClassSyllabus syllabus) async {
    final body = await getSyllabus(syllabus.url, jSessionId);
    return parseSyllabus(body);
  }
}
