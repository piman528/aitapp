import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future<Response> getSyllabusSession() async {
  debugPrint('getSyllabusSession');
  final headers = <String, String>{}
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final url = Uri.parse('$syllabusOrigin/ext_syllabus/');

  final res = await httpAccess(url, headers: headers);

  return res;
}

Future<String> getSyllabusListBody({
  String? campus,
  String? semester,
  int? week,
  String? altWeek,
  String? altPeriod,
  int? hour,
  required String year,
  required String jSessionId,
  String? searchWord,
  String? folder,
}) async {
  debugPrint('getSyllabusListBody');
  final headers = {
    'Origin': syllabusOrigin,
    'Referer': '$syllabusOrigin/ext_syllabus/',
    'Cookie': jSessionId,
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'syllabusTitleID': year,
    'indexID': folder ?? '',
    'subFolderFlag': 'on',
    'syllabusCampus': campus ?? '',
    'syllabusSemester': semester ?? '',
    'syllabusWeek': altWeek ?? '${week ?? ''}',
    'syllabusHour': altPeriod ?? '${hour ?? ''}',
    'kamokuName': '',
    'editorName': '',
    'freeWord': searchWord ?? '',
    'actionStatus': 'search',
    'subFolderFlag2': 'on',
    'bottonType': 'search',
  };

  final url = Uri.parse('$syllabusOrigin/ext_syllabus/syllabusSearch.do');

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}

Future<String> getSyllabus(String detailUrl, String jSessionId) async {
  debugPrint('getSyllabus');
  final headers = {
    'Cookie': jSessionId,
    'Referer': '$syllabusOrigin/ext_syllabus/syllabusSearch.do;$jSessionId',
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final url = Uri.parse(
    '$syllabusOrigin$detailUrl',
  );

  final res = await httpAccess(url, headers: headers);

  return res.body;
}

Future<String> refreshFiltersSession({
  required String year,
  required String jSessionId,
}) async {
  final tempjSession = jSessionId.split('=');
  final headers = {
    'Cookie': jSessionId,
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final data = {
    'syllabusTitleID': year,
    'indexID': '',
    'subFolderFlag': 'on',
    'syllabusCampus': '',
    'syllabusSemester': '',
    'syllabusWeek': '',
    'syllabusHour': '',
    'kamokuName': '',
    'editorName': '',
    'freeWord': '',
    'actionStatus': 'titleID',
    'subFolderFlag2': 'on',
    'bottonType': 'titleID',
  };

  final url = Uri.parse(
    '$syllabusOrigin/ext_syllabus/syllabusSearch.do;jsessionid=${tempjSession[1]}',
  );

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}
