import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/domain/features/get_lcam_data.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // この import を追加

part 'schedule.g.dart';

@Riverpod(keepAlive: true)
class ScheduleNotifier extends _$ScheduleNotifier {
  @override
  AsyncValue<Map<DateTime, List<UnivEvent>>> build() {
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
    state = AsyncValue.data(result);
  }

  List<UnivEvent> getEventsForSelectedDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return state.when(
      data: (data) => data[normalizedDay] ?? [],
      loading: () => [],
      error: (error, _) => [],
    );
  }
}
