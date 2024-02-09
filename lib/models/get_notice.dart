import 'dart:io';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_class_notice.dart';
import 'package:aitapp/infrastructure/parse_lcam.dart';
import 'package:aitapp/infrastructure/parse_univ_notice.dart';
import 'package:aitapp/models/cookies.dart';
import 'package:aitapp/models/notice.dart';
import 'package:aitapp/models/notice_detail.dart';
import 'package:aitapp/screens/open_file_pdf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GetNotice {
  late Cookies cookies;
  late String? token;
  Future<void> create(String id, String password) async {
    token = null;
    cookies = await getCookie();
    await loginLcam(id: id, password: password, cookies: cookies);
  }

  Future<List<Notice>> getNoticelist({
    required int page,
    required bool isCommon,
    required bool withLogin,
  }) async {
    if (withLogin) {
      final tempToken = parseStrutsToken(
        body: await getStrutsToken(
          cookies: cookies,
          isCommon: isCommon,
        ),
        isCommon: isCommon,
      );
      token = parseStrutsToken(
        body: await getNoticeBody(
          cookies: cookies,
          token: tempToken,
          isCommon: isCommon,
        ),
        isCommon: isCommon,
      );
    }

    final body = await getNoticeBodyNext(
      cookies: cookies,
      token: token!,
      pageNumber: page,
      isCommon: isCommon,
    );
    token = parseStrutsToken(body: body, isCommon: isCommon);

    if (isCommon) {
      return parseUnivNotice(body);
    } else {
      return parseClassNotice(body);
    }
  }

  Future<NoticeDetail> getNoticeDetail({
    required int pageNumber,
    required bool isCommon,
  }) async {
    if (cookies.jSessionId.isEmpty) {
      throw Exception('ログインできません');
    }
    final body = await getNoticeDetailBody(
      index: pageNumber,
      cookies: cookies,
      token: token!,
      isCommon: isCommon,
    );
    if (isCommon) {
      return parseUnivNoticeDetail(body);
    } else {
      return parseClassNoticeDetail(body);
    }
  }

  Future<void> shareFile(
    MapEntry<String, String> entry,
    BuildContext context,
  ) async {
    final response = await getFile(
      cookies: cookies,
      fileUrl: entry.value,
    );
    final contentType = response.headers['content-type']!;
    if (contentType != 'text/html;charset=utf-8') {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${entry.key}');
      if (entry.key.contains('.pdf')) {
        await file.writeAsBytes(response.bodyBytes).then((value) {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (BuildContext ctx) => OpenFilePdf(
                title: entry.key,
                file: file,
              ),
            ),
          );
        });
      } else {
        await file.writeAsBytes(response.bodyBytes);
        final xfile = [XFile(file.path)];
        await Share.shareXFiles(xfile);
      }
    } else {
      throw Exception('[shareFile]データの取得に失敗しました');
    }
  }
}
