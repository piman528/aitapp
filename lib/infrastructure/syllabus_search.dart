import 'package:http/http.dart' as http;

final _regexSplitSetCookies = RegExp(',(?=[^ ])');

Future<String> getSyllabusSearchBody() async {
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

  final cookies = <String>[];
  final setCookie = _getSetCookie(res.headers);
  if (setCookie.isNotEmpty) {
    for (final cookie in setCookie.split(_regexSplitSetCookies)) {
      cookies.add(cookie.split(';')[0]);
    }
  }
  return cookies[0];
}

Future<String> getSyllabusListBody(
  int campus,
  int semester,
  int week,
  int hour,
  String year,
  String jSessionId,
) async {
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
    'syllabusTitleID': '0020',
    'indexID': '',
    'subFolderFlag': 'on',
    'syllabusCampus': '$campus',
    'syllabusSemester': '$semester',
    'syllabusWeek': '$week',
    'syllabusHour': '$hour',
    'kamokuName': '',
    'editorName': '',
    'freeWord': '',
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

String _getSetCookie(Map<String, dynamic> headers) {
  for (final key in headers.keys) {
    // システムによって返却される "set-cookie" のケースはバラバラです。
    if (key.toLowerCase() == 'set-cookie') {
      return headers[key] as String;
    }
  }

  return '';
}
