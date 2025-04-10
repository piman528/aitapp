import 'package:aitapp/domain/types/assignment_event.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:flutter/material.dart';

class TimelineEventWidget extends StatelessWidget {
  const TimelineEventWidget({
    super.key,
    required this.event,
    required this.left,
    required this.width,
  });

  final CalendarEvent event;
  final double left;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (event is AssignmentEvent) {
      return _buildAssignmentEvent(event as AssignmentEvent);
    }
    return _buildRegularEvent(event);
  }

  Widget _buildRegularEvent(CalendarEvent event) {
    final startTime = event.startTime;
    final endTime = event.endTime;
    final minutesSinceMidnightStart =
        startTime.hour * 60 + startTime.minute + 30;
    final minutesSinceMidnightEnd = endTime.hour * 60 + endTime.minute + 30;
    final duration =
        (minutesSinceMidnightEnd - minutesSinceMidnightStart).toDouble();

    return Positioned(
      top: minutesSinceMidnightStart.toDouble(),
      left: left,
      width: width,
      child: Container(
        height: duration,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.2),
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (duration > 30) ...[
              const SizedBox(height: 4),
              Text(
                '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentEvent(AssignmentEvent event) {
    final dueTime = event.endTime;
    final minutesSinceMidnightDue = dueTime.hour * 60 + dueTime.minute + 30;
    final displayStart = minutesSinceMidnightDue - 68;

    return Positioned(
      top: displayStart.toDouble(),
      left: left,
      width: width,
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.2),
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '- ${dueTime.hour.toString().padLeft(2, '0')}:${dueTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
            Text(
              event.courseName,
              style: const TextStyle(
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
