import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/departur_schedule.dart';
import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:intl/intl.dart';

class NextDeparture {
  NextDeparture({
    required this.vehicle,
    required this.order,
    this.fromStation,
  });
  final Vehicle vehicle;
  final int order;
  final String? fromStation;

  int calculateTimeOffset(String startStation) {
    final stationsData = vehicle.stations.asMap().map((key, value) {
      return MapEntry(value.id, value.name);
    });
    final timesData = stationAmongTimes[vehicle.name]![vehicle.destination]!;
    final stations = stationsData.keys.toList();
    var offset = 0;

    final startIndex = stations.indexOf(startStation);
    final endStation =
        vehicle.destination == Destination.toFujigaoka ? 'L01' : 'L09';
    final endIndex = stations.indexOf(endStation);

    if (startIndex == -1 || endIndex == -1) {
      return 0;
    }

    // 方面に応じて計算方法を変える
    if (vehicle.destination == Destination.toFujigaoka) {
      // 八草→藤が丘方面
      for (var i = startIndex; i < stations.length - 1; i++) {
        final timePair = '${stations[i]}-${stations[i + 1]}';
        final time = int.parse(timesData[timePair] ?? '0');
        offset += time;
      }
    } else {
      // 藤が丘→八草方面
      for (var i = startIndex; i > 0; i--) {
        final timePair = '${stations[i - 1]}-${stations[i]}';
        final time = int.parse(timesData[timePair] ?? '0');
        offset += time;
      }
    }
    return offset;
  }

  List<DepartureSchedule> searchNextDeparture() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextDepartureList = <DepartureSchedule>[];
    late final String? todayDaiyaAlphabet;

    if (vehicle.name == 'linimo') {
      // 出発駅の設定
      var startStation = fromStation;
      startStation ??=
          vehicle.destination == Destination.toFujigaoka ? 'L09' : 'L01';

      // 時間オフセットを計算
      final timeOffset = calculateTimeOffset(startStation);

      // ダイヤ種別の決定
      final month = DateFormat('MM').format(now);
      final weekday = DateFormat('E').format(now);
      if (['土', '日'].contains(weekday) ||
          ['02', '03', '08', '09'].contains(month)) {
        todayDaiyaAlphabet = 'B';
      } else {
        todayDaiyaAlphabet = 'A';
      }

      var counter = 0;
      final todayDaiya =
          daiya[vehicle.name]?[vehicle.destination]?[todayDaiyaAlphabet];
      if (todayDaiya == null) {
        return [];
      }

      final hours = todayDaiya.keys;
      final offsetNow = now.subtract(Duration(minutes: timeOffset));

      for (final hour in hours) {
        final minutes = todayDaiya[hour];
        if (hour >= offsetNow.hour && minutes != null) {
          for (final minute in minutes) {
            if (minute > offsetNow.minute || hour > offsetNow.hour) {
              if (order == counter) {
                return nextDepartureList;
              } else {
                final baseTime = DateTime.utc(
                  offsetNow.year,
                  offsetNow.month,
                  offsetNow.day,
                  hour,
                  minute,
                );
                nextDepartureList.add(
                  DepartureSchedule(
                    departureTime: baseTime.add(Duration(minutes: timeOffset)),
                    arrivalTime: baseTime.add(
                      const Duration(minutes: 17),
                    ),
                    offset: timeOffset,
                  ),
                );
                counter++;
              }
            }
          }
        }
      }
    } else {
      todayDaiyaAlphabet = dayDaiya[DateFormat('yyyy-MM-dd').format(now)];
      if (todayDaiyaAlphabet == null || todayDaiyaAlphabet == '-') {
        return [];
      }

      var counter = 0;
      final todayDaiya =
          daiya[vehicle.name]?[vehicle.destination]?[todayDaiyaAlphabet];
      if (todayDaiya == null) {
        return [];
      }

      final hours = todayDaiya.keys;
      for (final hour in hours) {
        final minutes = todayDaiya[hour];
        if (hour >= now.hour && minutes != null) {
          for (final minute in minutes) {
            if (minute > now.minute || hour > now.hour) {
              if (order == counter) {
                return nextDepartureList;
              } else {
                nextDepartureList.add(
                  DepartureSchedule(
                    departureTime: DateTime.utc(
                      now.year,
                      now.month,
                      now.day,
                      hour,
                      minute,
                    ),
                    arrivalTime: DateTime.utc(
                      now.year,
                      now.month,
                      now.day,
                      hour,
                      minute,
                    ).add(const Duration(minutes: 10)),
                    offset: 0,
                  ),
                );
                counter++;
              }
            }
          }
        }
      }
    }

    return nextDepartureList;
  }
}
