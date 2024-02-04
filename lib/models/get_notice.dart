import 'dart:io';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_class_notice.dart';
import 'package:aitapp/infrastructure/parse_lcam.dart';
import 'package:aitapp/infrastructure/parse_univ_notice.dart';
import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/class_notice_detail.dart';
import 'package:aitapp/models/cookies.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/models/univ_notice_detail.dart';
import 'package:aitapp/provider/last_login_time_provider.dart';
import 'package:aitapp/screens/open_file_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GetNotice {
  late Cookies cookies;
  late String? token;
  Future<void> create(String id, String password, WidgetRef ref) async {
    token = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lastLoginTimeProvider.notifier).updateLastLoginTime();
    });
    cookies = await getCookie();
    await loginLcam(id: id, password: password, cookies: cookies);
  }

  Future<List<UnivNotice>> getUnivNoticelist(int page) async {
    const isCommon = true;
    final token1 = parseStrutsToken(
      body: await getStrutsToken(
        cookies: cookies,
        isCommon: isCommon,
      ),
      isCommon: isCommon,
    );
    final token2 = parseStrutsToken(
      body: await getUnivNoticeBody(cookies: cookies, token: token1),
      isCommon: isCommon,
    );
    final body = await getUnivNoticeBodyNext(
      cookies: cookies,
      token: token2,
      pageNumber: page,
    );
    token = parseStrutsToken(body: body, isCommon: isCommon);
    return parseUnivNotice(body);
  }

  Future<List<UnivNotice>> getUnivNoticelistNext(int page) async {
    const isCommon = true;
    final body = await getUnivNoticeBodyNext(
      cookies: cookies,
      token: token!,
      pageNumber: page,
    );
    token = parseStrutsToken(body: body, isCommon: isCommon);
    return parseUnivNotice(body);
  }

  Future<List<ClassNotice>> getClassNoticelist(int page) async {
    const isCommon = false;
    final token1 = parseStrutsToken(
      body: await getStrutsToken(
        cookies: cookies,
        isCommon: isCommon,
      ),
      isCommon: isCommon,
    );
    final token2 = parseStrutsToken(
      body: await getClassNoticeBody(cookies: cookies, token: token1),
      isCommon: isCommon,
    );
    final body = await getClassNoticeBodyNext(
      cookies: cookies,
      token: token2,
      pageNumber: page,
    );
    token = parseStrutsToken(body: body, isCommon: isCommon);
    return parseClassNotice(body);
  }

  Future<List<ClassNotice>> getClassNoticelistNext(int page) async {
    const isCommon = false;
    final body = await getClassNoticeBodyNext(
      cookies: cookies,
      token: token!,
      pageNumber: page,
    );
    token = parseStrutsToken(body: body, isCommon: isCommon);
    return parseClassNotice(body);
  }

  Future<UnivNoticeDetail> getUnivNoticeDetail(int pageNumber) async {
    if (cookies.jSessionId.isEmpty) {
      throw Exception('ログインできません');
    }
    final body = await getUnivNoticeDetailBody(
      index: pageNumber,
      cookies: cookies,
      token: token!,
    );
    return parseUnivNoticeDetail(body);
  }

  Future<ClassNoticeDetail> getClassNoticeDetail(int pageNumber) async {
    if (cookies.jSessionId.isEmpty) {
      throw Exception('ログインできません');
    }
    final body = await getClassNoticeDetailBody(
      index: pageNumber,
      cookies: cookies,
      token: token!,
    );
    return parseClassNoticeDetail(body);
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
