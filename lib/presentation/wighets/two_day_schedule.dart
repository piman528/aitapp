import 'package:aitapp/domain/types/assignment_event.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:flutter/material.dart';

class TwoDaySchedule extends StatelessWidget {
  const TwoDaySchedule({
    super.key,
    required this.selectedDate,
    required this.events,
  });

  final DateTime selectedDate;
  final Map<DateTime, List<CalendarEvent>> events;

  @override
  Widget build(BuildContext context) {
    final nextDay = selectedDate.add(const Duration(days: 1));
    final normalizedSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final normalizedNextDate = DateTime(
      nextDay.year,
      nextDay.month,
      nextDay.day,
    );

    return Column(
      children: [
        // 日付ヘッダー
        Row(
          children: [
            Expanded(
              child: _DayHeader(
                date: selectedDate,
                isToday: _isToday(selectedDate),
              ),
            ),
            Expanded(
              child: _DayHeader(
                date: nextDay,
                isToday: _isToday(nextDay),
              ),
            ),
          ],
        ),
        const Divider(height: 1),
        // スケジュール本体
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DaySchedule(
                  events: events[normalizedSelectedDate] ?? [],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _DaySchedule(
                  events: events[normalizedNextDate] ?? [],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.date,
    required this.isToday,
  });

  final DateTime date;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    final weekday = weekdays[date.weekday % 7];
    final isWeekend =
        date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: isToday
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      child: Column(
        children: [
          Text(
            '${date.month}/${date.day}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            weekday,
            style: TextStyle(
              color: isWeekend ? Colors.red : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySchedule extends StatelessWidget {
  const _DaySchedule({
    required this.events,
  });

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    // イベントを開始時刻でソート
    final sortedEvents = List<CalendarEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final startTime = event.startTime;
        final endTime = event.endTime;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (event is AssignmentEvent)
                      Icon(
                        Icons.assignment,
                        size: 16,
                        color: switch (event.status) {
                          SubmissionStatus.notSubmitted => Colors.red,
                          SubmissionStatus.submitted => Colors.green,
                          SubmissionStatus.needsGrading => Colors.orange,
                        },
                      )
                    else if (event is UnivEvent)
                      const Icon(Icons.school, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (event is UnivEvent &&
                    (event.location != null || event.teacher != null))
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      [
                        if (event.location != null) '📍 ${event.location}',
                        if (event.teacher != null) '👤 ${event.teacher}',
                      ].join(' '),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
