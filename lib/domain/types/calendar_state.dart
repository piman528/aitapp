import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum CalendarViewType {
  calendar,
  list,
  timeline,
}

class CalendarState {
  CalendarState({
    required this.events,
    required this.showDate,
    this.viewType = CalendarViewType.calendar,
  });

  final AsyncValue<Map<DateTime, List<CalendarEvent>>> events;
  final DateTime showDate;
  final CalendarViewType viewType;

  CalendarState copyWith({
    AsyncValue<Map<DateTime, List<CalendarEvent>>>? events,
    DateTime? showDate,
    CalendarViewType? viewType,
  }) {
    return CalendarState(
      events: events ?? this.events,
      showDate: showDate ?? this.showDate,
      viewType: viewType ?? this.viewType,
    );
  }
}
