import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/application/state/last_login/last_login.dart';
import 'package:aitapp/domain/features/get_lcam_data.dart';
import 'package:aitapp/domain/types/class.dart';
import 'package:aitapp/domain/types/class_timetable_state.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/last_login.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:aitapp/infrastructure/database/timetable_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'class_timetable.g.dart';

@Riverpod(keepAlive: true)
class ClassTimeTableNotifier extends _$ClassTimeTableNotifier {
  @override
  AsyncValue<ClassTimeTableState> build() {
    _loadFromDatabase();
    return const AsyncValue.loading();
  }

  Map<DayOfWeek, Map<int, Class>> get selectClassData {
    return state.value?.timetable[state.value?.selectYear ?? 0]
            ?[state.value?.selectSemester ?? Semester.early] ??
        {};
  }

  int get selectYear {
    return state.value?.selectYear ?? 0;
  }

  Semester get selectSemester {
    return state.value?.selectSemester ?? Semester.early;
  }

  void changeSelectYear(int year) {
    state = state.whenData(
      (data) => data.copyWith(selectYear: year),
    );
  }

  void changeSelectSemester(Semester semester) {
    state = state.whenData(
      (data) => data.copyWith(selectSemester: semester),
    );
  }

  Future<void> _loadFromDatabase() async {
    try {
      final timetable = await TimetableDatabase.instance.getTimetable();
      if (timetable.isNotEmpty) {
        state = AsyncValue.data(
          ClassTimeTableState(
            timetable: timetable,
            selectYear: timetable.entries.first.key,
            selectSemester: timetable.entries.first.value.keys.first,
          ),
        );
      } else {
        await fetchData();
      }
    } on Exception catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    final getPCLcamData = GetPCLcamData();
    final identity = ref.read(identityProvider);
    await getPCLcamData.create(identity!.id, identity.password);
    ref.read(lastLoginNotifierProvider.notifier).changeState(LastLogin.others);
    final result = await getPCLcamData.getClassTimeTable();

    // データベースに保存
    await TimetableDatabase.instance.saveTimetable(result);

    state = AsyncValue.data(
      ClassTimeTableState(
        timetable: result,
        selectYear: result.entries.first.key,
        selectSemester: result.entries.first.value.keys.first,
      ),
    );
  }
}
