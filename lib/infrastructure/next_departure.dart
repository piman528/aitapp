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
  DateTime? searchNextDeparture() {
    final now = DateTime.now();
    var counter = 0;

    final hours = daiya[vehicle]![destination]!['A']!.keys;
    for (final hour in hours) {
      if (hour >= now.hour) {
        final minutes = daiya[vehicle]![destination]!['A']![hour];
        if (minutes != null) {
          for (final minute in minutes) {
            if (minute > now.minute || hour > now.hour) {
              if (order == counter) {
                return DateTime(now.year, now.month, now.day, hour, minute);
              } else {
                counter++;
              }
            }
          }
        }
      }
    }
    return null;
  }
}
