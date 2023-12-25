import 'dart:io';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/parsing.dart';

class GetNotice {
  late List<String> cookies;
  late String token;
  Future<void> create(String id, String password) async {
    cookies = await getCookie();
    await loginLcam(id, password, cookies[0], cookies[1]);
  }

  Future<List<UnivNotice>> getUnivNoticelist(int page) async {
    const isCommon = true;
    final token1 = parseStrutsToken(
      body: await getStrutsToken(
        jSessionId: cookies[0],
        liveAppsCookie: cookies[1],
        isCommon: isCommon,
      ),
      isCommon: isCommon,
    );
    final token2 = parseStrutsToken(
      body: await getUnivNoticeBody(cookies[0], cookies[1], token1),
      isCommon: isCommon,
    );
    final body =
        await getUnivNoticeBodyNext(cookies[0], cookies[1], token2, page);
    token = parseStrutsToken(body: body, isCommon: isCommon);
    return parseUnivNotice(body);
  }

  Future<List<ClassNotice>> getClassNoticelist() async {
    const isCommon = false;
    final token1 = parseStrutsToken(
      body: await getStrutsToken(
        jSessionId: cookies[0],
        liveAppsCookie: cookies[1],
        isCommon: isCommon,
      ),
      isCommon: isCommon,
    );
    final token2 = parseStrutsToken(
      body: await getClassNoticeBody(cookies[0], cookies[1], token1),
      isCommon: isCommon,
    );
    final body =
        await getClassNoticeBodyNext(cookies[0], cookies[1], token2, 10);
    token = parseStrutsToken(body: body, isCommon: isCommon);
    return parseClassNotice(body);
  }

  Future<UnivNotice> getUnivNoticeDetail(int pageNumber) async {
    final body = await getUnivNoticeDetailBody(
      pageNumber,
      cookies[0],
      cookies[1],
      token,
    );
    return parseUnivNoticeDetail(body);
  }

  Future<ClassNotice> getClassNoticeDetail(int pageNumber) async {
    final body = await getClassNoticeDetailBody(
      pageNumber,
      cookies[0],
      cookies[1],
      token,
    );
    return parseClassNoticeDetail(body);
  }

  Future<void> shareFile(MapEntry<String, String> entry) async {
    final response = await getFile(
      cookies[0],
      cookies[1],
      entry.value,
    );
    try {
      final document = parseHtmlDocument(response.body);
      document.querySelectorAll('body').first.text;
    } catch (err) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${entry.key}');
      await file.writeAsBytes(response.bodyBytes);
      await Share.shareFiles(['${directory.path}/${entry.key}']);
    }
  }
}
