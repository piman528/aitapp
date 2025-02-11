import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/domain/features/get_lcam_data.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // この import を追加

part 'schedule.g.dart';

@Riverpod(keepAlive: true)
class ScheduleNotifier extends _$ScheduleNotifier {
  @override
  AsyncValue<CalendarState> build() {
    fetchData();
    return const AsyncValue.loading();
  }

  Future<void> fetchData() async {
    final id = ref.read(identityProvider);
    if (id == null) {
      throw Exception('ログインIDが取得できません');
    }
    final data = GetPCLcamData();
    await data.create(id.id, id.password);
    final result = await data.getShedule();
    state = AsyncValue.data(
      CalendarState(events: result, forcusedDay: DateTime.now()),
    );
  }

  List<UnivEvent> getEventsForSelectedDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return state.when(
      data: (data) => data.events[normalizedDay] ?? [],
      loading: () => [],
      error: (error, _) => [],
    );
  }

  void changeFocusedDay(DateTime day) {
    state = state.whenData(
      (data) => CalendarState(events: data.events, forcusedDay: day),
    );
  }
}
