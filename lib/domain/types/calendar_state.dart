import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarState {
  CalendarState({
    required this.events,
    required this.forcusedDay,
    this.view = CalendarView.month,
  });

  final Map<DateTime, List<CalendarEvent>> events;
  final DateTime forcusedDay;
  final CalendarView view;

  CalendarState copyWith({
    Map<DateTime, List<CalendarEvent>>? events,
    DateTime? forcusedDay,
    CalendarView? view,
  }) {
    return CalendarState(
      events: events ?? this.events,
      forcusedDay: forcusedDay ?? this.forcusedDay,
      view: view ?? this.view,
    );
  }
}
