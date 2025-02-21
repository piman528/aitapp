import 'package:aitapp/domain/types/assignment_event.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(this.events);

  final Map<DateTime, List<CalendarEvent>> events;

  @override
  List<dynamic> get appointments {
    final appointments = <dynamic>[];
    for (final dateEvents in events.values) {
      for (final event in dateEvents) {
        appointments.add(
          Appointment(
            subject: event.title,
            startTime: event.startTime,
            endTime: event.endTime,
            color: _getEventColor(event),
            notes: event is AssignmentEvent ? event.description : null,
          ),
        );
      }
    }
    return appointments;
  }

  Color _getEventColor(CalendarEvent event) {
    if (event is AssignmentEvent) {
      // 課題の提出状態に応じて色を変更
      return switch (event.status) {
        SubmissionStatus.notSubmitted => Colors.red, // 未提出は赤
        SubmissionStatus.submitted => Colors.green, // 提出済みは緑
        SubmissionStatus.needsGrading => Colors.orange, // 採点待ちはオレンジ
      };
    } else if (event is UnivEvent) {
      return Colors.blue; // 通常の大学イベントは青
    } else {
      return Colors.grey; // その他のイベントはグレー
    }
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments[index] as Appointment).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments[index] as Appointment).endTime;
  }

  @override
  String getSubject(int index) {
    return (appointments[index] as Appointment).subject;
  }

  @override
  Color getColor(int index) {
    return (appointments[index] as Appointment).color;
  }

  @override
  bool isAllDay(int index) {
    return (appointments[index] as Appointment).isAllDay;
  }
}
