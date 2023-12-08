import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/univ_notice.dart';

Future<List<ClassNotice>> getClassNoticelist() async {
  final cookies = await getCookie();
  await loginLcam(cookies[0], cookies[1]);
  final token = parseStrutsToken(
    body: await getStrutsToken(
      jSessionId: cookies[0],
      liveAppsCookie: cookies[1],
      isCommon: false,
    ),
    isCommon: false,
  );
  final body = await getClassNoticeBody(cookies[0], cookies[1], token!);
  return parseClassNotice(body);
}

Future<List<UnivNotice>> getUnivNoticelist() async {
  final cookies = await getCookie();
  await loginLcam(cookies[0], cookies[1]);
  final token = parseStrutsToken(
    body: await getStrutsToken(
      jSessionId: cookies[0],
      liveAppsCookie: cookies[1],
      isCommon: true,
    ),
    isCommon: true,
  );
  final token2 = parseStrutsToken(
    body: await getUnivNoticeBody(cookies[0], cookies[1], token!),
    isCommon: true,
  );
  final body = await getUnivNoticeBodyNext(cookies[0], cookies[1], token2!);
  return parseUnivNotice(body);
}
