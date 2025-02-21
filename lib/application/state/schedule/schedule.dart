import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/application/state/last_login/last_login.dart';
import 'package:aitapp/domain/features/get_lcam_data.dart';
import 'package:aitapp/domain/features/get_moodle_data.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/domain/types/last_login.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule.g.dart';

@Riverpod(keepAlive: true)
class ScheduleNotifier extends _$ScheduleNotifier {
  @override
  CalendarState build() {
    fetchData();
    return CalendarState(
      events: const AsyncValue.loading(),
      showDate: DateTime.now(),
    );
  }

  Future<void> fetchData() async {
    try {
      final id = ref.read(identityProvider);
      if (id == null) {
        throw Exception('ログインIDが取得できません');
      }

      // LCAMからのデータ取得
      final lcamData = GetPCLcamData();
      await lcamData.create(id.id, id.password);
      ref
          .read(lastLoginNotifierProvider.notifier)
          .changeState(LastLogin.others);
      final lcamEvents = await lcamData.getShedule();

      // Moodleからのデータ取得
      final moodleData = GetMoodleData();
      await moodleData.create(id.id, id.password);
      final moodleEvents = await moodleData.getAssignments();

      // 2つのイベントマップをマージ
      final mergedEvents = _mergeEventMaps(lcamEvents, moodleEvents);

      state = state.copyWith(
        events: AsyncValue.data(mergedEvents),
      );
    } catch (e, stack) {
      state = state.copyWith(
        events: AsyncValue.error(e, stack),
      );
    }
  }

  Map<DateTime, List<CalendarEvent>> _mergeEventMaps(
    Map<DateTime, List<CalendarEvent>> map1,
    Map<DateTime, List<CalendarEvent>> map2,
  ) {
    final result = <DateTime, List<CalendarEvent>>{};

    // すべての日付のセットを取得
    final allDates = {...map1.keys, ...map2.keys};

    for (final date in allDates) {
      result[date] = [
        ...(map1[date] ?? []),
        ...(map2[date] ?? []),
      ];
    }

    return result;
  }

  void changeShowDate(DateTime date) {
    state = state.copyWith(showDate: date);
  }

  void changeViewType(CalendarViewType viewType) {
    state = state.copyWith(viewType: viewType);
  }
}
