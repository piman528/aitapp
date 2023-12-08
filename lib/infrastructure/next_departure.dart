import 'package:aitapp/const.dart';

class NextDeparture {
  NextDeparture({
    required this.vehicle,
    required this.destination,
    required this.order,
  });
  final String vehicle;
  final String destination;
  final int order;
  String searchNextDeparture() {
    final now = DateTime.now();
    var counter = 0;

    final hours = Vehicle.daiya[vehicle]![destination]?.keys;
    for (final hour in hours!) {
      if (hour >= now.hour) {
        final minutes = Vehicle.daiya[vehicle]?[destination]?[hour];
        if (minutes != null) {
          for (final minute in minutes) {
            if (minute > now.minute || hour > now.hour) {
              if (order == counter) {
                final stringMinute = minute.toString().padLeft(2, '0');
                final stringHour = hour.toString().padLeft(2, '0');
                return '$stringHour:$stringMinute';
              } else {
                counter++;
              }
            }
          }
        }
      }
    }
    return '';
  }
}
