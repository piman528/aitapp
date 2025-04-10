import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:flutter/material.dart';

class TimelineHeaderWidget extends StatelessWidget {
  const TimelineHeaderWidget({
    super.key,
    required this.allDayEvents,
  });

  final List<CalendarEvent> allDayEvents;

  @override
  Widget build(BuildContext context) {
    if (allDayEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          const Text('終日'),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Column(
                children: allDayEvents.map(_buildAllDayEvent).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDayEvent(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.2),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        event.title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
