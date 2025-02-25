// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/cookies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const constHeader = {
  'Accept-Language': 'ja',
  'Connection': 'keep-alive',
  'Accept-Encoding': 'gzip',
  'Accept': '*/*',
};
const secFetchHeader = {
  'Sec-Fetch-Site': 'same-origin',
  'Sec-Fetch-Mode': 'navigate',
  'Sec-Fetch-Dest': 'document',
};
const contentTypeHeader = {
  'Content-Type': 'application/x-www-form-urlencoded',
};

Future<Response> httpAccess(
  Uri uri, {
  required Map<String, String> headers,
  Map<String, String>? body,
}) async {
  late final Response res;
  if (body != null) {
    res = await http.post(uri, headers: headers, body: body);
  } else {
    res = await http.get(uri, headers: headers);
  }
  if (res.statusCode != 200) {
    throw Exception('http.get error: statusCode= ${res.statusCode}');
  }
  return res;
}

Future<String> getSchedule({required Cookies cookie}) async {
  debugPrint('getSchedule');
  final headers = {
    'Origin': 'https://$origin',
    'Cookie': cookie.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    '_mode': '5',
    'EXCLUDE_SET': '',
  };

  final url = Uri.parse(
    'https://$origin/portalv2/schedule/scheduleForHome/getSchedule',
  );

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}

Future<String> reload({
  required Cookies cookie,
  required String token,
}) async {
  debugPrint('reload');
  final headers = {
    'Origin': 'https://$origin',
    'Cookie': cookie.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    '_screenIdentifier': 'home',
    '_screenInfoDisp': '',
    '_scrollTop': '148',
  };

  final url = Uri.parse('https://$origin/portalv2/home/home/reload');

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}

Future<String> preAccess({required Cookies cookie}) async {
  debugPrint('preAccess');
  final url = Uri.parse('https://$origin/portalv2/login/preLogin/preLogin');
  final headers = {
    'Origin': 'https://$origin',
    'Referer': 'https://$origin/',
    'Cookie': cookie.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'mistakeChecker': '0',
    'clientLocationUrl': 'https://$origin/',
  };

  final res = await httpAccess(url, headers: headers, body: data);

  final setCookie = _getSetCookie(res.headers);
  return setCookie;
}

Future<String> initLogin({
  required String id,
  required String password,
  required Cookies cookies,
}) async {
  debugPrint('initLogin');
  final headers = {
    'Origin': 'https://$origin',
    'Referer': 'https://$origin/portalv2/',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'userID': id,
    'password': password,
    'selectLocale': 'ja',
    'authenticMethod': '1',
    'mistakeChecker': '0',
    'EXCLUDE_SET': '',
  };

  final url = Uri.parse('https://$origin/portalv2/login/login/initLogin');

  final res = await http.post(url, headers: headers, body: data);
  return res.body;
}

Future<String> generalPurpose({
  required Cookies cookies,
  required String token,
}) async {
  final headers = {
    'Origin': 'https://$origin',
    'Referer': 'https://$origin/portalv2/login/login/initLogin',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'headTitle': 'ホーム',
    'menuCode': 'A00',
    'nextPath': '/classsupporttop/classSupportTop/initialize',
    '_screenIdentifier': '',
    '_screenInfoDisp': '',
    '_scrollTop': '0',
  };

  final url = Uri.parse('https://$origin/portalv2/common/generalPurpose/');

  final res = await httpAccess(url, headers: headers, body: data);
  return res.body;
}

Future<String> searchTimeTable({
  required Cookies cookies,
  required String token,
  required String year,
  required String semester,
}) async {
  final headers = {
    'Origin': 'https://$origin',
    'Referer': 'https://$origin/portalv2/common/generalPurpose/',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'schoolYear': year,
    'semesterCode': semester,
    '_screenIdentifier': 'SC_A00_01',
    '_screenInfoDisp': '',
    '_scrollTop': '494',
  };

  final url = Uri.parse(
    'https://$origin/portalv2/portaltopcommon/timeTableForTop/searchTimeTable',
  );

  final res = await httpAccess(url, headers: headers, body: data);
  return res.body;
}

Future<Cookies> pcGetCookie() async {
  debugPrint('pcgetcookie');
  final url = Uri.parse('https://$origin/portalv2/');
  final headers = <String, String>{}
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final res = await httpAccess(url, headers: headers);

  final setCookie = _getSetCookie(res.headers);
  final cookies = setCookie.split(RegExp(',(?=[^ ])'));
  return Cookies(jSessionId: cookies[0], liveAppsCookie: cookies[1]);
}

Future<Cookies> getCookie() async {
  debugPrint('getcookie');
  final url = Uri.parse('https://$origin/portalv2/sp');
  final headers = <String, String>{}
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final res = await httpAccess(url, headers: headers);

  final setCookie = _getSetCookie(res.headers);
  final cookies = setCookie.split(RegExp(',(?=[^ ])'));
  return Cookies(jSessionId: cookies[0], liveAppsCookie: cookies[1]);
}

Future<bool> canLoginLcam({
  required String id,
  required String password,
}) async {
  debugPrint('canLoginLcam');
  final headers = <String, String>{}
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'userId': id,
    'password': password,
  };

  final url = Uri.parse('https://$origin/portalv2/login/login/spAppLogin/');

  final res = await httpAccess(url, headers: headers, body: data);
  final json = jsonDecode(res.body) as Map;
  if (json['status'] == 'success') {
    return true;
  }
  return false;
}

Future<String> loginLcam({
  required String id,
  required String password,
  required Cookies cookies,
}) async {
  debugPrint('loginlcam');
  final headers = {
    'Origin': 'https://$origin',
    'Referer': 'https://$origin/portalv2/sp',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'userID': id,
    'password': password,
    'selectLocale': 'ja',
    'mode': 'sp',
    'userDivision': '2',
    'spFlg': '1',
    'locale': 'ja',
    'spAppFlag': '1',
    'clientLocationUrl': 'https://$origin/',
  };

  final url = Uri.parse(
    'https://$origin/portalv2/login/login/smartPhoneLogin',
  );

  final res = await httpAccess(url, headers: headers, body: data);
  return res.body;
}

Future<String> getStrutsToken({
  required Cookies cookies,
  required bool isCommon,
}) async {
  debugPrint('gettoken');
  String contactType;
  if (isCommon) {
    contactType = 'commonContact';
  } else {
    contactType = 'classContact';
  }
  final headers = {
    'Cookie': cookies.toString(),
    'Referer':
        'https://$origin/portalv2/smartphone/smartPhoneHome/nextPage/contactNotice',
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final url = Uri.parse(
    'https://$origin/portalv2/smartphone/smartPhoneContactNotice/nextPage/$contactType',
  );

  final res = await httpAccess(url, headers: headers);
  return res.body;
}

Future<String> getNoticeBody({
  required Cookies cookies,
  required String token,
  required bool isCommon,
}) async {
  final noticeType = isCommon ? 'Common' : 'Class';
  debugPrint('get${noticeType}NoticeBody');
  final headers = {
    'Origin': 'https://$origin',
    'Referer':
        'https://$origin/portalv2/smartphone/smartPhoneContactNotice/nextPage/${noticeType.toLowerCase()}Contact',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'unReadFlg': '1',
    'listPageNo': '1',
    '_screenIdentifier': 'smartPhone${noticeType}ContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://$origin/portalv2/smartphone/smartPhone${noticeType}Contact/select${noticeType}ContactList',
  );

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}

Future<String> getNoticeBodyNext({
  required Cookies cookies,
  required String token,
  required int pageNumber,
  required bool isCommon,
}) async {
  final noticeType = isCommon ? 'Common' : 'Class';
  debugPrint('get${noticeType}NoticeBodyNext');
  final headers = {
    'Origin': 'https://origin',
    'Referer':
        'https://$origin/portalv2/smartphone/smartPhone${noticeType}Contact/select${noticeType}ContactList',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'unReadFlg': '1',
    'listPageNo': '$pageNumber',
    '_screenIdentifier': 'smartPhone${noticeType}ContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://$origin/portalv2/smartphone/smartPhone${noticeType}Contact/nextSelect${noticeType}ContactList',
  );

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}

Future<String> getClassTimeTableBody({required Cookies cookies}) async {
  debugPrint('getClassTimeTableBody');
  final headers = {
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final url = Uri.parse(
    'https://$origin/portalv2/smartphone/smartPhoneHome/nextPage/timeTable',
  );

  final res = await httpAccess(url, headers: headers);

  return res.body;
}

Future<String> getNoticeDetailBody({
  required int index,
  required Cookies cookies,
  required String token,
  required bool isCommon,
}) async {
  final noticeType = isCommon ? 'Common' : 'Class';
  debugPrint('get${noticeType}NoticeDetailBody');
  final headers = {
    'Origin': 'https://origin',
    'Referer':
        'https://$origin/portalv2/smartphone/smartPhone${noticeType}Contact/nextSelect${noticeType}ContactList',
    'Cookie': cookies.toString(),
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader)
    ..addAll(contentTypeHeader);

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    '_screenIdentifier': 'smartPhone${noticeType}ContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://$origin/portalv2/smartphone/smartPhone${noticeType}Contact/goDetail/$index',
  );

  final res = await httpAccess(url, headers: headers, body: data);
  return res.body;
}

Future<Response> getFile({
  required Cookies cookies,
  required String fileUrl,
}) async {
  debugPrint('getfile');
  final headers = {
    'Cookie': cookies.toString(),
  }..addAll(constHeader);
  final url = Uri.parse('https://$origin$fileUrl');

  final res = await httpAccess(url, headers: headers);

  return res;
}

String _getSetCookie(Map<String, dynamic> headers) {
  for (final header in headers.entries) {
    // システムによって返却される "set-cookie" のケースはバラバラ

    String? jSessionId;
    String? liveAppCookie;

    if (header.key.toLowerCase() == 'set-cookie') {
      if (header.value.toString().toLowerCase().contains('jsessionid') &&
          header.value.toString().toLowerCase().contains('liveapps-cookie')) {
        return header.value as String;
      } else if (header.value.toString().toLowerCase().contains('jsessionid')) {
        jSessionId = (header.value as String).split(',').last;
      } else if (header.value
          .toString()
          .toLowerCase()
          .contains('liveapps-cookie')) {
        liveAppCookie = header.value as String;
      }
      if (jSessionId != null && liveAppCookie != null) {
        return '$jSessionId, $liveAppCookie';
      } else if (jSessionId != null) {
        return jSessionId;
      } else if (liveAppCookie != null) {
        return liveAppCookie;
      }
    }
  }

  return '';
}
