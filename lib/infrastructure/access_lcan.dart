// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:aitapp/const.dart';
import 'package:aitapp/models/cookies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Cookies> getCookie() async {
  debugPrint('getcookie');
  final headers = {
    'Accept': '*/*',
    'Accept-Language': 'ja-JP;q=1, en-JP;q=0.9',
    'Connection': 'keep-alive',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse('$origin/portalv2/sp');

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

  final setCookie = _getSetCookie(res.headers);
  final cookies = setCookie.split(RegExp(',(?=[^ ])'));
  return Cookies(jSessionId: cookies[0], liveAppsCookie: cookies[1]);
}

Future<bool> canLoginLcam({
  required String id,
  required String password,
}) async {
  debugPrint('canLoginLcam');
  final headers = {
    'Accept': 'application/json, text/plain, */*',
    'Sec-Fetch-Site': 'cross-site',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'cors',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'empty',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'userId': id,
    'password': password,
  };

  final url = Uri.parse('$origin/portalv2/login/login/spAppLogin/');

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }
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
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': origin,
    'Referer': '$origin/portalv2/sp',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'document',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Accept-Encoding': 'gzip',
  };

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

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }
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
    'Sec-Fetch-Site': 'same-origin',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Connection': 'keep-alive',
    'Sec-Fetch-Mode': 'navigate',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Referer':
        '$origin/portalv2/smartphone/smartPhoneHome/nextPage/contactNotice',
    'Sec-Fetch-Dest': 'document',
    'Accept-Language': 'ja',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse(
    '$origin/portalv2/smartphone/smartPhoneContactNotice/nextPage/$contactType',
  );

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }
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
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': origin,
    'Referer':
        '$origin/portalv2/smartphone/smartPhoneContactNotice/nextPage/${noticeType.toLowerCase()}Contact',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'document',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Accept-Encoding': 'gzip',
  };

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

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

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
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': origin,
    'Referer':
        '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/select${noticeType}ContactList',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

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

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

  return res.body;
}

Future<String> getClassTimeTableBody({required Cookies cookies}) async {
  debugPrint('getClassTimeTableBody');
  final headers = {
    'Sec-Fetch-Site': 'none',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Connection': 'keep-alive',
    'Sec-Fetch-Mode': 'navigate',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'ja',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse(
    '$origin/portalv2/smartphone/smartPhoneHome/nextPage/timeTable',
  );

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

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
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': origin,
    'Referer':
        '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/nextSelect${noticeType}ContactList',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    '_screenIdentifier': 'smartPhone${noticeType}ContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    '$origin/portalv2/smartphone/smartPhone${noticeType}Contact/goDetail/$index',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }
  return res.body;
}

Future<Response> getFile({
  required Cookies cookies,
  required String fileUrl,
}) async {
  debugPrint('getfile');
  final headers = {
    'Accept': '*/*',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Accept-Language': 'ja',
    'Connection': 'keep-alive',
    'Accept-Encoding': 'gzip',
  };
  final url = Uri.parse('$origin$fileUrl');

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

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
