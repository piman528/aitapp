// ignore_for_file: lines_longer_than_80_chars
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:universal_html/parsing.dart';

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
    for (final cookie in setCookie.split(RegExp(',(?=[^ ])'))) {
      cookies.add(cookie.split(';')[0]);
    }
  }
  return cookies;
}

Future<bool> loginLcam(
  String id,
  String password,
  String jSessionId,
  String liveAppsCookie,
) async {
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

  final document = parseHtmlDocument(res.body);
  try {
    document
        .querySelectorAll('#_errorInformation > ul > li:nth-child(1)')
        .first
        .text;
  } catch (err) {
    return true;
  }
  return false;
}

Future<String> getStrutsToken({
  required String jSessionId,
  required String liveAppsCookie,
  required bool isCommon,
}) async {
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

Future<String> getClassNoticeBodyNext(
  String jSessionId,
  String liveAppsCookie,
  String token,
  int pageNumber,
) async {
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
    'Cookie':
        '$jSessionId; $liveAppsCookie; $jSessionId; L-CamApp=Y; $liveAppsCookie',
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
  int pageNumber,
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

Future<String> getClassTimeTableBody(
  String jSessionId,
  String liveAppsCookie,
) async {
  final headers = {
    'Sec-Fetch-Site': 'none',
    'Cookie':
        '$jSessionId; $liveAppsCookie; $jSessionId; L-CamApp=Y; LiveApps-Cookie=$liveAppsCookie',
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

Future<String> getClassNoticeDetailBody(
  int index,
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
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneContactNotice/nextPage/classContact/',
    'Connection': 'keep-alive',
    'Cookie':
        '$jSessionId; $liveAppsCookie; $jSessionId; L-CamApp=Y; $liveAppsCookie',
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

Future<String> getUnivNoticeDetailBody(
  int index,
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
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/nextSelectCommonContactList',
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
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneCommonContact/goDetail/$index',
  );

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) {
    throw Exception('http.post error: statusCode= $status');
  }

  return res.body;
}

Future<Response> getFile(
  String jSessionId,
  String liveAppsCookie,
  String fileUrl,
) async {
  final headers = {
    'Accept': '*/*',
    'Cookie':
        '$jSessionId; $liveAppsCookie; $jSessionId; L-CamApp=Y; $liveAppsCookie',
    'User-Agent': 'L-Cam/1.12.03 CFNetwork/1490.0.4 Darwin/23.2.0',
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
