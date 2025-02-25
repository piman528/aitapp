import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/presentation/wighets/schedule/calendar_cell.dart';
import 'package:flutter/material.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.events,
  });

  final DateTime month;
  final Map<DateTime, List<CalendarEvent>> events;

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(month.year, month.month);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final numberOfCells = _calculateRequiredCells(
      firstDayOfMonth: firstDayOfMonth,
      lastDayOfMonth: lastDayOfMonth,
      firstWeekday: firstWeekday,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            '${month.month}月',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.5,
          ),
          itemCount: numberOfCells,
          itemBuilder: (context, index) {
            final dayOffset = index - firstWeekday;
            final date = firstDayOfMonth.add(Duration(days: dayOffset));

            if (date.month != month.month) {
              return const SizedBox();
            }

            final isToday = _isToday(date);

            final normalizedDate = DateTime(date.year, date.month, date.day);
            final dayEvents = events[normalizedDate] ?? [];

            return CalendarCell(
              date: date,
              events: dayEvents,
              isToday: isToday,
            );
          },
        ),
      ],
    );
  }

  int _calculateRequiredCells({
    required DateTime firstDayOfMonth,
    required DateTime lastDayOfMonth,
    required int firstWeekday,
  }) {
    final daysInMonth = lastDayOfMonth.day;
    final firstDayOffset = firstWeekday;
    final weeksNeeded = ((daysInMonth + firstDayOffset) / 7).ceil();
    return weeksNeeded * 7;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
