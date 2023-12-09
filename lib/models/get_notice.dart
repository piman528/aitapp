import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/univ_notice.dart';

class GetNotice {
  late final List<String> cookies;
  late String token;
  Future<void> create() async {
    cookies = await getCookie();
    await loginLcam(cookies[0], cookies[1]);
  }

  Future<List<UnivNotice>> getUnivNoticelist() async {
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
        await getUnivNoticeBodyNext(cookies[0], cookies[1], token2, 10);
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
}
