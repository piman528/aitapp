import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/application/state/last_login/last_login.dart';
import 'package:aitapp/domain/features/get_lcam_data.dart';
import 'package:aitapp/domain/features/get_moodle_data.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/domain/types/last_login.dart';
import 'package:aitapp/infrastructure/database/event_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule.g.dart';

@Riverpod(keepAlive: true)
class ScheduleNotifier extends _$ScheduleNotifier {
  @override
  CalendarState build() {
    checkAndFetchData();
    return CalendarState(
      events: const AsyncValue.loading(),
      showDate: DateTime.now(),
    );
  }

  Future<void> checkAndFetchData() async {
    final db = EventDatabase.instance;
    if (!await db.hasEvents()) {
      await fetchData();
    } else {
      // データベースからイベントを取得しつつ、Moodleのイベントも常に最新を取得
      await fetchMoodleData();
    }
  }

  // データを取得してデータベースに保存するメソッド
  // 既存データは削除せず、新しい予定のみ追加する
  Future<void> fetchData() async {
    try {
      final id = ref.read(identityProvider);
      if (id == null) {
        throw Exception('ログインIDが取得できません');
      }

      final db = EventDatabase.instance;

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

      // データベースに保存（重複は自動的にスキップされる）
      // イベントに同じタイトル・開始時間・終了時間のものがあれば挿入しない
      // 並行処理で保存を高速化
      await Future.wait([
        // LCAMのイベントを保存
        Future.wait(
          lcamEvents.values
              .expand((events) => events)
              .map(db.insertCalendarEvent),
        ),
        // Moodleのイベントを保存
        Future.wait(
          moodleEvents.values
              .expand((events) => events)
              .map(db.insertCalendarEvent),
        ),
      ]);

      // データベースから最新のイベントを取得
      final dbEvents = await db.getAllEvents();

      state = state.copyWith(
        events: AsyncValue.data(dbEvents),
      );
    } catch (e, stack) {
      state = state.copyWith(
        events: AsyncValue.error(e, stack),
      );
    }
  }

  // データベースからイベントを取得し、さらにMoodleから最新のイベントも取得する
  Future<void> fetchMoodleData() async {
    try {
      final id = ref.read(identityProvider);
      if (id == null) {
        throw Exception('ログインIDが取得できません');
      }

      // データベースから既存のイベントを取得
      final db = EventDatabase.instance;
      final dbEvents = await db.getAllEvents();

      // Moodleから最新のイベントを取得
      final moodleData = GetMoodleData();
      await moodleData.create(id.id, id.password);
      final moodleEvents = await moodleData.getAssignments();

      // Moodleのイベントをデータベースに保存（更新用）
      await Future.wait(
        moodleEvents.values
            .expand((events) => events)
            .map(db.insertCalendarEvent),
      );

      state = state.copyWith(
        events: AsyncValue.data(dbEvents),
      );
    } catch (e, stack) {
      state = state.copyWith(
        events: AsyncValue.error(e, stack),
      );
    }
  }

  void changeShowDate(DateTime date) {
    state = state.copyWith(showDate: date);
  }

  void changeViewType(CalendarViewType viewType) {
    state = state.copyWith(viewType: viewType);
  }
}
