class DepartureSchedule {
  DepartureSchedule({
    required this.departureTime,
    required this.arrivalTime,
    required this.offset,
  });
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int offset;
}
