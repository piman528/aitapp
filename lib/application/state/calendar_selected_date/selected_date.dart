import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_date.g.dart';

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void select(DateTime date) {
    state = date;
  }
}
