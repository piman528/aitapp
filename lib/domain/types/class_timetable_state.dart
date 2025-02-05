import 'package:aitapp/domain/types/class.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_timetable_state.freezed.dart';

@freezed
class ClassTimeTableState with _$ClassTimeTableState {
  const factory ClassTimeTableState({
    required Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> timetable,
    required int selectYear,
    required Semester selectSemester,
  }) = _ClassTimeTableState;
}
