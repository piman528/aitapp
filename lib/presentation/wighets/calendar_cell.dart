import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({super.key, required this.details, required this.events});
  final MonthCellDetails details;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(2),
            child: Text(
              '${details.date.day}',
              style: TextStyle(
                fontSize: 14,
                color: details.visibleDates.contains(details.date)
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          if (events.isNotEmpty) ...[
            ...events.take(4).map(
                  (event) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(2, 0, 2, 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            if (events.length > 4)
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 1),
                child: Text(
                  '他${events.length - 4}件',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
