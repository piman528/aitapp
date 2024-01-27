import 'package:aitapp/const.dart';
import 'package:aitapp/infrastructure/get_class_timetable.dart';
import 'package:aitapp/models/class.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
