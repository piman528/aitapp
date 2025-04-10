import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/presentation/wighets/schedule/timeline_view/timeline_day_events_widget.dart';
import 'package:aitapp/presentation/wighets/schedule/timeline_view/timeline_header_widget.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({
    super.key,
    required this.events,
    required this.selectedDate,
  });

  final Map<DateTime, List<CalendarEvent>> events;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final dayEvents = events[DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        )] ??
        [];

    // イベントを終日イベントとそれ以外に分類
    final allDayEvents = dayEvents.where((event) {
      final start = event.startTime;
      final end = event.endTime;
      return start.hour == 0 &&
          start.minute == 0 &&
          end.hour == 23 &&
          end.minute == 59;
    }).toList();

    final regularEvents = dayEvents.where((event) {
      final start = event.startTime;
      final end = event.endTime;
      return !(start.hour == 0 &&
          start.minute == 0 &&
          end.hour == 23 &&
          end.minute == 59);
    }).toList();

    return Column(
      children: [
        TimelineHeaderWidget(allDayEvents: allDayEvents),
        TimelineDayEventsWidget(
          events: regularEvents,
          selectedDate: selectedDate,
        ),
      ],
    );
  }
}
