import 'package:aitapp/domain/types/calendar_event.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: 25 * 60.0, // 1時間あたり60ピクセル
            child: Stack(
              children: [
                // 時間ラベル
                _buildTimeLabels(),
                // 現在時刻のインジケーター
                _buildCurrentTimeIndicator(),
                // イベントの表示
                _buildEvents(),
              ],
            ),
          ),
        );
      },
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
    final now = DateTime.now();
    if (!_isSameDay(now, selectedDate)) {
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

  Widget _buildEvents() {
    final dayEvents = events[DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        )] ??
        [];

    return Stack(
      children: dayEvents.map((event) {
        final startTime = event.startTime;
        final endTime = event.endTime;

        final minutesSinceMidnightStart =
            startTime.hour * 60 + startTime.minute + 30;
        final minutesSinceMidnightEnd = endTime.hour * 60 + endTime.minute + 30;
        final duration = minutesSinceMidnightEnd - minutesSinceMidnightStart;

        return Positioned(
          top: minutesSinceMidnightStart.toDouble(),
          left: 60, // 時間ラベルの幅
          right: 8,
          child: Container(
            height: duration.toDouble(),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
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
      }).toList(),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
