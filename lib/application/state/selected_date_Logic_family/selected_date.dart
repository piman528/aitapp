import 'package:aitapp/application/state/calendar_selected_date/selected_date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_date.g.dart';

@riverpod
bool selectedFamily(SelectedFamilyRef ref, DateTime date) {
  final selectedDate = ref.watch(selectedDateProvider);
  return date.year == selectedDate.year &&
      date.month == selectedDate.month &&
      date.day == selectedDate.day;
}
