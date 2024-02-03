import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/infrastructure/parse_lcam.dart';
import 'package:aitapp/models/class.dart';
import 'package:aitapp/provider/last_login_time_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Map<DayOfWeek, Map<int, Class>>> getClassTimeTable(
  String id,
  String password,
  WidgetRef ref,
) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(lastLoginTimeProvider.notifier).updateLastLoginTime();
  });
  final cookies = await getCookie();
  await loginLcam(id, password, cookies[0], cookies[1]);
  final body = await getClassTimeTableBody(cookies[0], cookies[1]);
  return parseClassTimeTable(body);
}

class ClassTimeTableNotifier
    extends StateNotifier<AsyncValue<Map<DayOfWeek, Map<int, Class>>>> {
  ClassTimeTableNotifier() : super(const AsyncValue.loading());

  Future<void> fetchData(String id, String password, WidgetRef ref) async {
    state = const AsyncValue.loading();
    try {
      final result = await getClassTimeTable(id, password, ref);
      state = AsyncValue.data(result);
    } on Exception catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}

final classTimeTableProvider = StateNotifierProvider<ClassTimeTableNotifier,
    AsyncValue<Map<DayOfWeek, Map<int, Class>>>>(
  (ref) {
    return ClassTimeTableNotifier();
  },
);
