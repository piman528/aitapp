import 'package:aitapp/application/config/const.dart';
import 'package:intl/intl.dart';

class NextDeparture {
  NextDeparture({
    required this.vehicle,
    required this.destination,
    required this.order,
  });
  final String vehicle;
  final String destination;
  final int order;
  List<DateTime> searchNextDeparture() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextDepartureList = <DateTime>[];
    late final String? todayDaiyaAlphabet;
    if (vehicle == 'linimo') {
      // 4月〜7月・10月〜1月の平日はA	 	土休日と8月・9月・2月・3月の平日（学校休業期間)はB
      final month = DateFormat('MM').format(now);
      final weekday = DateFormat('E').format(now);
      if (['土', '日'].contains(weekday) ||
          ['02', '03', '08', '09'].contains(month)) {
        todayDaiyaAlphabet = 'B';
      } else {
        todayDaiyaAlphabet = 'A';
      }
    } else {
      todayDaiyaAlphabet = dayDaiya[DateFormat('yyyy-MM-dd').format(now)];
      if (todayDaiyaAlphabet == null || todayDaiyaAlphabet == '-') {
        return [];
      }
    }
    var counter = 0;
    final todayDaiya = daiya[vehicle]?[destination]?[todayDaiyaAlphabet];

    final hours = todayDaiya!.keys;
    for (final hour in hours) {
      final minutes = todayDaiya[hour];
      if (hour >= now.hour && minutes != null) {
        for (final minute in minutes) {
          if (minute > now.minute || hour > now.hour) {
            if (order == counter) {
              return nextDepartureList;
            } else {
              nextDepartureList.add(
                DateTime.utc(now.year, now.month, now.day, hour, minute),
              );
              counter++;
            }
          }
        }
      }
    }
    return nextDepartureList;
  }
}
