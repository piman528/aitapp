import 'package:aitapp/domain/types/station.dart';

class StationSchedule {
  StationSchedule({
    required this.station,
    required this.time,
    this.amongTime,
  });
  final Station station;
  final DateTime time;
  final int? amongTime;
}
