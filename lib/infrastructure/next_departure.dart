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
    final todayDaiya = dayDaiya['${now.year}-${now.month}-${now.day}'];
    if (todayDaiya == null) {
      return null;
    }

    final hours = daiya[vehicle]![destination]![todayDaiya]!.keys;
    for (final hour in hours) {
      if (hour >= now.hour) {
        final minutes = daiya[vehicle]![destination]![todayDaiya]![hour];
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
