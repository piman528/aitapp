import 'package:aitapp/infrastructure/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _regexSplitSetCookies = RegExp(',(?=[^ ])');

Future<List<String>> getCookie() async {
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

  final cookies = <String>[];

  final setCookie = _getSetCookie(res.headers);
  if (setCookie.isNotEmpty) {
    for (final cookie in setCookie.split(_regexSplitSetCookies)) {
      cookies.add(cookie.split(';')[0]);
    }
  }
  return cookies;
}

Future<void> loginLcam(String jSessionId, String liveAppsCookie) async {
  final id = await SecureStorage.instance.read(key: 'id');
  final password = await SecureStorage.instance.read(key: 'password');
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
    'Cookie': '$jSessionId; $liveAppsCookie',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'userID': '$id',
    'password': '$password',
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

  // print(res.body);
  // var document = parseHtmlDocument(res.body);
  // final topStorytitle = document
  //     .querySelectorAll(
  //         'body > div:nth-child(3) > table > tbody > tr > td:nth-child(2)')
  //     .first
  //     .text;
  // debugPrint(topStorytitle);
}

Future<String> getStrutsToken(
  String jSessionId,
  String liveAppsCookie,
  bool isCommon,
) async {
  String contactType;
  if (isCommon) {
    contactType = 'commonContact';
  } else {
    contactType = 'classContact';
  }
  final headers = {
    'Sec-Fetch-Site': 'same-origin',
    'Cookie': '$jSessionId; $liveAppsCookie',
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

Future<String> getClassNoticeBody(
  String jSessionId,
  String liveAppsCookie,
  String token,
) async {
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
    'Cookie': '$liveAppsCookie; $jSessionId',
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

Future<String> getUnivNoticeBody(
  String jSessionId,
  String liveAppsCookie,
  String token,
) async {
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
    'Cookie':
        '$jSessionId; $liveAppsCookie; $jSessionId; L-CamApp=Y; $liveAppsCookie',
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

Future<String> getUnivNoticeBodyNext(
  String jSessionId,
  String liveAppsCookie,
  String token,
) async {
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
    'Cookie':
        '$jSessionId; $liveAppsCookie; $jSessionId; L-CamApp=Y; $liveAppsCookie',
    'Sec-Fetch-Dest': 'document',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'org.apache.struts.taglib.html.TOKEN': token,
    'commonContactCateIdRcv': '',
    'reportDateFromRcv': '',
    'reportDateToRcv': '',
    'unReadFlg': '1',
    'listPageNo': '10',
    '_screenIdentifier': 'smartPhoneCommonContactList',
    '_scrollTop': '0',
  };

  final url = Uri.parse(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/nextSelectCommonContactList',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) throw Exception('http.post error: statusCode= $status');

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
