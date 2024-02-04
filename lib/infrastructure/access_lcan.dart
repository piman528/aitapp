// ignore_for_file: lines_longer_than_80_chars

import 'package:aitapp/models/cookies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:universal_html/parsing.dart';

Future<Cookies> getCookie() async {
  debugPrint('getcookie');
  final headers = {
    'Accept': '*/*',
    'Accept-Language': 'ja-JP;q=1, en-JP;q=0.9',
    'Connection': 'keep-alive',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse('https://lcam.aitech.ac.jp/portalv2/sp');

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

  final setCookie = _getSetCookie(res.headers);
  final cookies = setCookie.split(RegExp(',(?=[^ ])'));
  return Cookies(jSessionId: cookies[0], liveAppsCookie: cookies[1]);
}

Future<bool> loginLcam({
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
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer': 'https://lcam.aitech.ac.jp/portalv2/sp',
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
    'clientLocationUrl': 'https://lcam.aitech.ac.jp/',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/login/login/smartPhoneLogin',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

  final isLogin = parseHtmlDocument(res.body)
      .querySelectorAll('#_errorInformation > ul > li:nth-child(1)')
      .isEmpty;
  if (isLogin) {
    return true;
  }
  return false;
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
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/contactNotice',
    'Sec-Fetch-Dest': 'document',
    'Accept-Language': 'ja',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneContactNotice/nextPage/$contactType',
  );

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }
  return res.body;
}

Future<String> getClassNoticeBody({
  required Cookies cookies,
  required String token,
}) async {
  debugPrint('getClassNoticeBody');
  final headers = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer':
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneContactNotice/nextPage/classContact',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'document',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'contactKindCode': '',
    'reportDateStart': '',
    'reportDateEnd': '',
    'unReadFlg': '1',
    'listPageNo': '1',
    '_screenIdentifier': 'smartPhoneClassContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneClassContact/selectClassContactList',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

  return res.body;
}

Future<String> getClassNoticeBodyNext({
  required Cookies cookies,
  required String token,
  required int pageNumber,
}) async {
  debugPrint('getClassNoticeBodyNext');
  final headers = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer':
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneClassContact/selectClassContactList',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'contactKindCode': '',
    'reportDateStart': '',
    'reportDateEnd': '',
    'unReadFlg': '1',
    'listPageNo': '$pageNumber',
    '_screenIdentifier': 'smartPhoneClassContactList',
    '_scrollTop': '96',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneClassContact/nextSelectClassContactList',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

  return res.body;
}

Future<String> getUnivNoticeBody({
  required Cookies cookies,
  required String token,
}) async {
  debugPrint('getUnivNoticeBody');
  final headers = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer':
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneContactNotice/nextPage/commonContact/',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'commonContactCateIdRcv': '',
    'reportDateFromRcv': '',
    'reportDateToRcv': '',
    'unReadFlg': '1',
    'listPageNo': '1',
    '_screenIdentifier': 'smartPhoneCommonContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/selectCommonContactList',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }
  return res.body;
}

Future<String> getUnivNoticeBodyNext({
  required Cookies cookies,
  required String token,
  required int pageNumber,
}) async {
  debugPrint('getUnivNoticeBodyNext');
  final headers = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer':
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/selectCommonContactList',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'commonContactCateIdRcv': '',
    'reportDateFromRcv': '',
    'reportDateToRcv': '',
    'unReadFlg': '1',
    'listPageNo': '$pageNumber',
    '_screenIdentifier': 'smartPhoneCommonContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/nextSelectCommonContactList',
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
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/timeTable',
  );

  final res = await http.get(url, headers: headers);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.get error: statusCode= $status');
  }

  return res.body;
}

Future<String> getClassNoticeDetailBody({
  required int index,
  required Cookies cookies,
  required String token,
}) async {
  debugPrint('getClassNoticeDetailBody');
  final headers = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer':
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneContactNotice/nextPage/classContact/',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    '_screenIdentifier': 'smartPhoneClassContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneClassContact/goDetail/$index',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }
  return res.body;
}

Future<String> getUnivNoticeDetailBody({
  required int index,
  required Cookies cookies,
  required String token,
}) async {
  debugPrint('getUnivNoticeDetailBody');
  final headers = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Sec-Fetch-Site': 'same-origin',
    'Accept-Language': 'ja',
    'Sec-Fetch-Mode': 'navigate',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Origin': 'https://lcam.aitech.ac.jp',
    'Referer':
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/nextSelectCommonContactList',
    'Connection': 'keep-alive',
    'Cookie': '${cookies.jSessionId}; ${cookies.liveAppsCookie}',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'commonContactCateIdRcv': '',
    'reportDateFromRcv': '',
    'reportDateToRcv': '',
    'unReadFlg': '1',
    'listPageNo': '1',
    '_screenIdentifier': 'smartPhoneCommonContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/goDetail/$index',
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
  final url = Uri.parse('https://lcam.aitech.ac.jp$fileUrl');

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
