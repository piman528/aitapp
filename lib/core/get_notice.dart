import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/tab/notice_list.dart';

Future<List<ClassNotice>> getClassNoticelist() async {
  final cookies = await getCookie();
  await loginLcam(cookies[0], cookies[1]);
  final token = await getStrutsToken(cookies[0], cookies[1], false);
  final body = await getClassNoticeBody(cookies[0], cookies[1], token!);
  return parseClassNotice(body);
}

Future<List<UnivNotice>> getUnivNoticelist() async {
  final cookies = await getCookie();
  await loginLcam(cookies[0], cookies[1]);
  final token = await getStrutsToken(cookies[0], cookies[1], true);
  final body = await getUnivNoticeBody(cookies[0], cookies[1], token!);
  return parseUnivNotice(body);
}
