import 'package:aitapp/domain/types/class_period.dart';

class UnivEvent {
  UnivEvent({
    required this.event,
    this.location,
    this.teacher,
    this.period,
  });

  final String event;
  final String? location;
  final String? teacher;
  final ClassPeriod? period;

  @override
  String toString() {
    return 'UnivEvent{event: $event,location: $location, teacher: $teacher, period: $period}\n';
  }
}
