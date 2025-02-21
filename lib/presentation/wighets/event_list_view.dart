import 'package:aitapp/domain/types/assignment_event.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:flutter/material.dart';

class EventListView extends StatelessWidget {
  const EventListView({
    super.key,
    required this.events,
  });

  final Map<DateTime, List<CalendarEvent>> events;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final allEvents = <CalendarEvent>[];

    // すべてのイベントを1つのリストにまとめる
    for (final dateEvents in events.values) {
      allEvents.addAll(dateEvents);
    }

    // これからのイベントのみをフィルタリングし、日付でソート
    final upcomingEvents = allEvents
        .where((event) => event.endTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    if (upcomingEvents.isEmpty) {
      return const Center(
        child: Text('予定されているイベントはありません'),
      );
    }

    return ListView.builder(
      itemCount: upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = upcomingEvents[index];
        final isFirstOfDay = index == 0 ||
            !_isSameDay(
              upcomingEvents[index - 1].startTime,
              event.startTime,
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFirstOfDay) ...[
              _DateHeader(date: event.startTime),
              const Divider(height: 1),
            ],
            _EventListTile(event: event),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    final weekday = weekdays[date.weekday % 7];
    final now = DateTime.now();
    final isToday = _isSameDay(date, now);
    final isTomorrow = _isSameDay(
      date,
      now.add(const Duration(days: 1)),
    );

    String dateText;
    if (isToday) {
      dateText = '今日';
    } else if (isTomorrow) {
      dateText = '明日';
    } else {
      dateText = '${date.month}/${date.day}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Text(
        '$dateText（$weekday）',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class _EventListTile extends StatelessWidget {
  const _EventListTile({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final timeString =
        '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}';

    Widget? subtitle;
    if (event is UnivEvent) {
      final univEvent = event as UnivEvent;
      subtitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeString),
          if (univEvent.location != null) Text('📍 ${univEvent.location}'),
          if (univEvent.teacher != null) Text('👤 ${univEvent.teacher}'),
        ],
      );
    } else if (event is AssignmentEvent) {
      final assignmentEvent = event as AssignmentEvent;
      subtitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeString),
          Text('コース: ${assignmentEvent.courseName}'),
          _buildStatusChip(assignmentEvent),
        ],
      );
    } else {
      subtitle = Text(timeString);
    }

    return ListTile(
      leading: _buildLeadingIcon(),
      title: Text(
        event.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle,
      isThreeLine: true,
    );
  }

  Widget _buildLeadingIcon() {
    if (event is AssignmentEvent) {
      final assignmentEvent = event as AssignmentEvent;
      return Icon(
        Icons.assignment,
        color: switch (assignmentEvent.status) {
          SubmissionStatus.notSubmitted => Colors.red,
          SubmissionStatus.submitted => Colors.green,
          SubmissionStatus.needsGrading => Colors.orange,
        },
      );
    } else if (event is UnivEvent) {
      return const Icon(Icons.school, color: Colors.blue);
    }
    return const Icon(Icons.event);
  }

  Widget _buildStatusChip(AssignmentEvent event) {
    return Chip(
      label: Text(
        switch (event.status) {
          SubmissionStatus.notSubmitted => '未提出',
          SubmissionStatus.submitted => '提出済み',
          SubmissionStatus.needsGrading => '採点待ち',
        },
      ),
      backgroundColor: switch (event.status) {
        SubmissionStatus.notSubmitted => Colors.red.shade100,
        SubmissionStatus.submitted => Colors.green.shade100,
        SubmissionStatus.needsGrading => Colors.orange.shade100,
      },
      labelStyle: TextStyle(
        color: switch (event.status) {
          SubmissionStatus.notSubmitted => Colors.red.shade900,
          SubmissionStatus.submitted => Colors.green.shade900,
          SubmissionStatus.needsGrading => Colors.orange.shade900,
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
