import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/class_period.dart';

class UnivEvent extends CalendarEvent {
  UnivEvent({
    this.location,
    this.teacher,
    this.period,
    required super.title,
    required super.startTime,
    required super.endTime,
  });
  // 時限から時間を設定するファクトリーメソッド
  factory UnivEvent.fromPeriod({
    required String title,
    required ClassPeriod period,
    required DateTime date,
    String? location,
    String? teacher,
  }) {
    final periodTime = classPeriods[period];

    final startTime = DateTime(
      date.year,
      date.month,
      date.day,
      periodTime![0].hour,
      periodTime[0].minute,
    );

    final endTime = DateTime(
      date.year,
      date.month,
      date.day,
      periodTime[1].hour,
      periodTime[1].minute,
    );

    return UnivEvent(
      title: title,
      startTime: startTime,
      endTime: endTime,
      location: location,
      teacher: teacher,
      period: period,
    );
  }

  final String? location;
  final String? teacher;
  final ClassPeriod? period;
  @override
  String toString() {
    return 'UnivEvent{event: $title,location: $location, teacher: $teacher, period: $period}\n';
  }
}
