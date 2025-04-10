import 'package:aitapp/domain/types/assignment_event.dart';
import 'package:aitapp/domain/types/calendar_event.dart';

class TimelineLayoutHelpers {
  // イベントが重なっているかチェックする関数
  bool isOverlapping(CalendarEvent event1, CalendarEvent event2) {
    // 課題イベントの場合は表示期間（1時間）を考慮
    var start1 = event1.startTime;
    var end1 = event1.endTime;
    var start2 = event2.startTime;
    var end2 = event2.endTime;

    if (event1 is AssignmentEvent) {
      start1 = event1.startTime.subtract(const Duration(hours: 1));
      end1 = event1.startTime;
    }
    if (event2 is AssignmentEvent) {
      start2 = event2.startTime.subtract(const Duration(hours: 1));
      end2 = event2.startTime;
    }

    return start1.isBefore(end2) && start2.isBefore(end1);
  }

  // イベントをコラム（列）に分配
  List<List<CalendarEvent>> distributeEventsToColumns(
    List<CalendarEvent> events,
  ) {
    if (events.isEmpty) {
      return [];
    }

    // イベントを開始時刻でソート
    final sortedEvents = List<CalendarEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    // コラムのリスト（各コラムは重ならないイベントのリスト）
    final columns = <List<CalendarEvent>>[];

    // 各イベントを適切なコラムに配置
    for (final event in sortedEvents) {
      var placed = false;

      // 既存のコラムをチェック
      for (final column in columns) {
        // そのコラムの最後のイベントと重なっていないかチェック
        if (column.isEmpty || !isOverlapping(column.last, event)) {
          column.add(event);
          placed = true;
          break;
        }
      }

      // 既存のコラムに配置できなかった場合、新しいコラムを作成
      if (!placed) {
        columns.add([event]);
      }
    }

    return columns;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
