import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/models/class.dart';

Future<Map<DayOfWeek, Map<int, Class>>> getClassTimeTable(
  String id,
  String password,
) async {
  final cookies = await getCookie();
  await loginLcam(id, password, cookies[0], cookies[1]);
  final body = await getClassTimeTableBody(cookies[0], cookies[1]);
  return parseClassTimeTable(body);
}
