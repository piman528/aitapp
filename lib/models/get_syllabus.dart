import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/infrastructure/syllabus_search.dart';
import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/syllabus_filter.dart';

class GetSyllabus {
  late String jSessionId;
  Future<SyllabusFilters> create() async {
    final res = await getSyllabusSession();
    final filters = parseSyllabusFilters(res);
    jSessionId = filters.cookies[0];
    return filters;
  }

  Future<List<ClassSyllabus>> getSyllabusList({
    DayOfWeek? dayOfWeek,
    int? classPeriod,
    String? searchWord,
    String? altWeek,
    String? altPeriod,
    String? campus,
    String? semester,
    String? folder,
    required String year,
  }) async {
    final body = await getSyllabusListBody(
      campus: campus,
      semester: semester,
      week: dayOfWeekToInt[dayOfWeek],
      hour: classPeriod,
      year: year,
      jSessionId: jSessionId,
      searchWord: searchWord,
      altWeek: altWeek,
      altPeriod: altPeriod,
      folder: folder,
    );
    return parseSyllabus(body);
  }

  Future<ClassSyllabusDetail> getSyllabusDetail(ClassSyllabus syllabus) async {
    final body = await getSyllabus(syllabus.url, jSessionId);
    return parseSyllabusDetail(body);
  }
}
