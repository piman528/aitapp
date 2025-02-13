import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(Map<DateTime, List<CalendarEvent>> events) {
    final appointments = <Appointment>[];
    events.forEach((date, eventList) {
      for (final event in eventList) {
        if (event is UnivEvent) {
          appointments.add(
            Appointment(
              startTime: event.startTime,
              endTime: event.endTime,
              subject: event.title,
              location: event.location ?? '',
              notes: event.teacher ?? '',
              color: Colors.blue.withOpacity(0.8),
            ),
          );
        } else {
          appointments.add(
            Appointment(
              startTime: event.startTime,
              endTime: event.endTime,
              subject: event.title,
              location: '',
              notes: '',
              color: Colors.blue.withOpacity(0.8),
            ),
          );
        }
      }
    });
    this.appointments = appointments;
  }

  @override
  String getLocation(int index) => appointments![index].location as String;

  @override
  String getNotes(int index) => appointments![index].notes as String;
}
