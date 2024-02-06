// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:aitapp/const.dart';
import 'package:aitapp/models/cookies.dart';
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

Future<Cookies> getCookie() async {
  debugPrint('getcookie');
  final url = Uri.parse('$origin/portalv2/sp');

  final res = await httpAccess(url, headers: constHeader);

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

  final url = Uri.parse('$origin/portalv2/login/login/spAppLogin/');

  final res = await httpAccess(url, headers: headers, body: data);
  final json = jsonDecode(res.body) as Map;
  if (json['status'] == 'success') {
    return true;
  }
  return false;
}

Future<void> loginLcam({
  required String id,
  required String password,
  required Cookies cookies,
}) async {
  debugPrint('loginlcam');
  final headers = {
    'Origin': origin,
    'Referer': '$origin/portalv2/sp',
    'Cookie': cookies.toHeaderString,
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
    'clientLocationUrl': '$origin/',
  };

  final url = Uri.parse(
    '$origin/portalv2/login/login/smartPhoneLogin',
  );

  await httpAccess(url, headers: headers, body: data);
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
    'Cookie': cookies.toHeaderString,
    'Referer':
        '$origin/portalv2/smartphone/smartPhoneHome/nextPage/contactNotice',
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final url = Uri.parse(
    '$origin/portalv2/smartphone/smartPhoneContactNotice/nextPage/$contactType',
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
    'Origin': origin,
    'Referer':
        '$origin/portalv2/smartphone/smartPhoneContactNotice/nextPage/${noticeType.toLowerCase()}Contact',
    'Cookie': cookies.toHeaderString,
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
    '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/select${noticeType}ContactList',
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
    'Origin': origin,
    'Referer':
        '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/select${noticeType}ContactList',
    'Cookie': cookies.toHeaderString,
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
    '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/nextSelect${noticeType}ContactList',
  );

  final res = await httpAccess(url, headers: headers, body: data);

  return res.body;
}

Future<String> getClassTimeTableBody({required Cookies cookies}) async {
  debugPrint('getClassTimeTableBody');
  final headers = {
    'Cookie': cookies.toHeaderString,
  }
    ..addAll(constHeader)
    ..addAll(secFetchHeader);

  final url = Uri.parse(
    '$origin/portalv2/smartphone/smartPhoneHome/nextPage/timeTable',
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
    'Origin': origin,
    'Referer':
        '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/nextSelect${noticeType}ContactList',
    'Cookie': cookies.toHeaderString,
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
    '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/goDetail/$index',
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
    'Cookie': cookies.toHeaderString,
  }..addAll(constHeader);
  final url = Uri.parse('$origin$fileUrl');

  final res = await httpAccess(url, headers: headers);

  return res;
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
