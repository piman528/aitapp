import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/wighet/notices.dart';
import 'package:flutter/material.dart';

Future<List<ClassNotice>> getClassNoticelist() async {
  final cookies = await getCookie();
  await loginLcam(cookies[0], cookies[1]);
  final token = parseStrutsToken(
    await getStrutsToken(cookies[0], cookies[1], false),
    false,
  );
  final body = await getClassNoticeBody(cookies[0], cookies[1], token!);
  return parseClassNotice(body);
}

Future<List<UnivNotice>> getUnivNoticelist() async {
  final cookies = await getCookie();
  await loginLcam(cookies[0], cookies[1]);
  final token = parseStrutsToken(
    await getStrutsToken(cookies[0], cookies[1], true),
    true,
  );
  final token2 = parseStrutsToken(
    await getUnivNoticeBody(cookies[0], cookies[1], token!),
    true,
  );
  final body = await getUnivNoticeBodyNext(cookies[0], cookies[1], token2!);
  return parseUnivNotice(body);
}
