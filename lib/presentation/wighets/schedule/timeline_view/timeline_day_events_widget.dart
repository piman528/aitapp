import 'package:aitapp/domain/features/timeline_layout_helpers.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/presentation/wighets/schedule/timeline_view/timeline_event_widget.dart';
import 'package:flutter/material.dart';

class TimelineDayEventsWidget extends StatelessWidget {
  const TimelineDayEventsWidget({
    super.key,
    required this.events,
    required this.selectedDate,
  });

  final List<CalendarEvent> events;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 25 * 60.0, // 1時間あたり60ピクセル
          child: Stack(
            children: [
              _buildTimeLabels(),
              _buildCurrentTimeIndicator(),
              _buildEvents(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLabels() {
    return Column(
      children: List.generate(25, (hour) {
        return SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Divider(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentTimeIndicator() {
    final timelineLayoutHelpers = TimelineLayoutHelpers();
    final now = DateTime.now();
    if (!timelineLayoutHelpers.isSameDay(now, selectedDate)) {
      return const SizedBox.shrink();
    }

    final minutesSinceMidnight = now.hour * 60 + now.minute + 30;
    final topPosition = minutesSinceMidnight.toDouble();

    return Positioned(
      top: topPosition,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        color: Colors.red,
      ),
    );
  }

  Widget _buildEvents(BuildContext context) {
    final timelineLayoutHelpers = TimelineLayoutHelpers();
    final columns = timelineLayoutHelpers.distributeEventsToColumns(events);

    return Stack(
      children: [
        ...columns.asMap().entries.expand((columnEntry) {
          final columnIndex = columnEntry.key;
          final column = columnEntry.value;
          final availableWidth = MediaQuery.of(context).size.width - 68.0;
          final columnWidth = availableWidth / columns.length;
          final left = 60.0 + (columnIndex * columnWidth);
          final width = columnWidth - 4.0; // 4pxのマージンを確保

          return column.map((event) {
            return TimelineEventWidget(
              event: event,
              left: left,
              width: width,
            );
          });
        }),
      ],
    );
  }
}
