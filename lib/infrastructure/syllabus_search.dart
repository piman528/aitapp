import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Response> getSyllabusSession() async {
  debugPrint('getSyllabusSession');
  final headers = {
    'Sec-Fetch-Site': 'none',
    'Connection': 'keep-alive',
    'Sec-Fetch-Mode': 'navigate',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'ja',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse('https://syllabus.aitech.ac.jp/ext_syllabus/');

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

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
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://syllabus.aitech.ac.jp',
    'Referer': 'https://syllabus.aitech.ac.jp/ext_syllabus/',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'document',
    'Cookie': jSessionId,
    'Accept-Encoding': 'gzip',
  };

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

  final url =
      Uri.parse('https://syllabus.aitech.ac.jp/ext_syllabus/syllabusSearch.do');

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }
  return res.body;
}

Future<String> getSyllabus(String detailUrl, String jSessionId) async {
  debugPrint('getSyllabus');
  final headers = {
    'Sec-Fetch-Site': 'same-origin',
    'Cookie': jSessionId,
    'Connection': 'keep-alive',
    'Sec-Fetch-Mode': 'navigate',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Referer':
        'https://syllabus.aitech.ac.jp/ext_syllabus/syllabusSearch.do;$jSessionId',
    'Sec-Fetch-Dest': 'document',
    'Accept-Language': 'ja',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse(
    'https://syllabus.aitech.ac.jp$detailUrl',
  );

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

  return res.body;
}

Future<String> refreshFiltersSession({
  required String year,
  required String jSessionId,
}) async {
  final tempjSession = jSessionId.split('=');
  final headers = {
    'Sec-Fetch-Site': 'none',
    'Connection': 'keep-alive',
    'Sec-Fetch-Mode': 'navigate',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'ja',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
    'Cookie': jSessionId,
  };

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
    'https://syllabus.aitech.ac.jp/ext_syllabus/syllabusSearch.do;jsessionid=${tempjSession[1]}',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

  return res.body;
}
