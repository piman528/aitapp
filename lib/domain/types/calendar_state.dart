import 'package:aitapp/domain/types/event.dart';

class CalendarState {
  CalendarState({required this.events, required this.forcusedDay});

  final Map<DateTime, List<UnivEvent>> events;
  final DateTime forcusedDay;
}
