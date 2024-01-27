import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_html.dart';
import 'package:aitapp/models/class.dart';
import 'package:aitapp/provider/last_login_time_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Map<DayOfWeek, Map<int, Class>>> getClassTimeTable(
  String id,
  String password,
  WidgetRef ref,
) async {
  final cookies = await getCookie();
  await loginLcam(id, password, cookies[0], cookies[1]);
  ref.read(lastLoginTimeProvider.notifier).updateLastLoginTime();
  final body = await getClassTimeTableBody(cookies[0], cookies[1]);
  return parseClassTimeTable(body);
}
