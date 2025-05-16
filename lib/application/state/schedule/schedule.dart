import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/application/state/last_login/last_login.dart';
import 'package:aitapp/domain/features/get_lcam_data.dart';
import 'package:aitapp/domain/features/get_moodle_data.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:aitapp/domain/types/last_login.dart';
import 'package:aitapp/infrastructure/database/event_database.dart';
import 'package:aitapp/presentation/dialogs/select_calendar_dialog.dart'; // Add this import
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

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

  // イベントデータをデバイスのカレンダーに登録するメソッド
  Future<void> addEventsToDeviceCalendar(BuildContext context) async {
    final deviceCalendarPlugin = DeviceCalendarPlugin();

    try {
      // 権限の確認とリクエスト
      var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !(permissionsGranted.data ?? false)) {
        permissionsGranted = await deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            !(permissionsGranted.data ?? false)) {
          await Fluttertoast.showToast(msg: 'カレンダーへのアクセス権限がありません');
          return;
        }
      }

      // 利用可能なカレンダーを取得
      final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
      if (!calendarsResult.isSuccess ||
          calendarsResult.data == null ||
          calendarsResult.data!.isEmpty) {
        await Fluttertoast.showToast(msg: '利用可能なカレンダーが見つかりません');
        return;
      }

      // 書き込み可能なカレンダーをフィルタリング
      final writableCalendars = calendarsResult.data!
          .where((cal) => cal.isReadOnly == false)
          .toList();
      if (writableCalendars.isEmpty) {
        await Fluttertoast.showToast(msg: '書き込み可能なカレンダーが見つかりません');
        return;
      }

      // カレンダー選択ダイアログを表示
      final selectedCalendar = await showDialog<Calendar>(
        context: context,
        builder: (context) => SelectCalendarDialog(
          calendars: writableCalendars,
          onSelect: (calendar) => Navigator.of(context).pop(calendar),
        ),
      );

      // キャンセルされた場合
      if (selectedCalendar == null) {
        return;
      }

      final targetCalendarId = selectedCalendar.id;

      // 選択したカレンダーの情報をデバッグ出力
      debugPrint(
          'Selected calendar: ${selectedCalendar.name} (ID: $targetCalendarId, Default: ${selectedCalendar.isDefault})');

      // データベースからイベントを取得
      final db = EventDatabase.instance;
      final eventsMap = await db.getAllEvents();
      final allEvents = eventsMap.values.expand((list) => list).toList();

      if (allEvents.isEmpty) {
        await Fluttertoast.showToast(msg: '登録するイベントがありません');
        return;
      }

      var successCount = 0;
      var failCount = 0;

      // イベントをデバイスカレンダーに登録
      for (final appEvent in allEvents) {
        // 終日イベントかどうかを判定
        final isAllDay = appEvent.startTime.hour == 0 &&
            appEvent.startTime.minute == 0 &&
            appEvent.endTime.hour == 23 &&
            appEvent.endTime.minute == 59 &&
            appEvent.endTime.day == appEvent.startTime.day;

        // 終日イベントの場合はスキップ
        if (isAllDay) {
          continue;
        }

        final deviceEvent = Event(
          description: 'AIT App からエクスポートされた予定',
          targetCalendarId,
          title: appEvent.title,
          start: tz.TZDateTime.from(appEvent.startTime, tz.local),
          end: tz.TZDateTime.from(appEvent.endTime, tz.local),
          location: appEvent is UnivEvent ? appEvent.location : null,
        );

        final createResult =
            await deviceCalendarPlugin.createOrUpdateEvent(deviceEvent);
        if (createResult?.isSuccess ?? false) {
          successCount++;
        } else {
          failCount++;
          // より詳細なエラーログを出力
          debugPrint(
            'Failed to add event: ${appEvent.title} [${appEvent.startTime} - ${appEvent.endTime}], Errors: ${createResult?.errors.map((e) => '${e.errorCode}: ${e.errorMessage}').join('; ')}',
          );
        }
      }

      // 結果をユーザーに通知 (より具体的に)
      if (successCount > 0 && failCount == 0) {
        await Fluttertoast.showToast(msg: '$successCount 件のイベントを正常に登録しました');
      } else if (successCount > 0 && failCount > 0) {
        await Fluttertoast.showToast(
          msg: '$successCount 件登録、$failCount 件失敗しました。詳細はデバッグログを確認してください。',
        );
      } else if (successCount == 0 && failCount > 0) {
        await Fluttertoast.showToast(msg: 'イベントの登録に失敗しました。詳細はデバッグログを確認してください。');
      } else {
        // allEventsが空だった場合など
        await Fluttertoast.showToast(msg: '登録対象のイベントがありませんでした。');
      }
    } catch (e, stack) {
      // スタックトレースも出力
      await Fluttertoast.showToast(msg: 'カレンダー登録中にエラーが発生しました: $e');
      debugPrint('Device Calendar Error: $e\n$stack'); // スタックトレースも出力
    }
  }
}
