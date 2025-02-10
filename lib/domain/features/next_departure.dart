import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/departure_schedule.dart';
import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/station_shedule.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/domain/types/vehicles.dart';
import 'package:intl/intl.dart';

class NextDeparture {
  NextDeparture({
    required this.vehicle,
    required this.fromStation,
  });
  final Vehicle vehicle;
  final Station fromStation;

  // 各駅の所要時間
  List<StationSchedule> getSchedule(DateTime departureTime) {
    final stations = vehicle.stations;
    final timesData = stationAmongTimes[vehicle.vehicle]?[vehicle.destination];
    final offset = calculateTimeOffset();
    List<Station> orderedStations;
    if (vehicle.destination == Destination.toFujigaoka ||
        vehicle.destination == Destination.toAIT) {
      orderedStations = stations.reversed.toList();
    } else {
      orderedStations = stations;
    }

    var totalMinutes = 0;
    final stationSchedule = <StationSchedule>[];

    for (var i = 0; i < orderedStations.length; i++) {
      final currentStation = orderedStations[i];
      var travelTime = 0;
      if (i < orderedStations.length - 1) {
        final nextStation = orderedStations[i + 1];
        var timePair = '${currentStation.id}-${nextStation.id}';
        if (vehicle.destination == Destination.toFujigaoka ||
            vehicle.destination == Destination.toAIT) {
          timePair = '${nextStation.id}-${currentStation.id}';
        }
        travelTime = int.parse(timesData?[timePair] ?? '0');
      }
      stationSchedule.add(
        StationSchedule(
          station: currentStation,
          time: departureTime.add(Duration(minutes: totalMinutes - offset)),
          amongTime: travelTime,
        ),
      );
      totalMinutes += travelTime;
    }
    return stationSchedule;
  }

  // ダイヤ種別の取得
  String? getDaiyaAlphabet() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    if (vehicle.vehicle == Vehicles.linimo) {
      // ダイヤ種別の決定
      final month = DateFormat('MM').format(now);
      final weekday = DateFormat('E').format(now);
      if (['土', '日'].contains(weekday) ||
          ['02', '03', '08', '09'].contains(month)) {
        return 'B';
      } else {
        return 'A';
      }
    } else {
      final todayDaiyaAlphabet = dayDaiya[DateFormat('yyyy-MM-dd').format(now)];
      if (todayDaiyaAlphabet == null || todayDaiyaAlphabet == '-') {
        return null;
      }
      return todayDaiyaAlphabet;
    }
  }

  // オフセットの計算
  int calculateTimeOffset() {
    final stations = vehicle.stations;
    final timesData = stationAmongTimes[vehicle.vehicle]![vehicle.destination]!;
    var offset = 0;
    final startIndex = stations.indexOf(fromStation);
    if (startIndex == -1) {
      return 0;
    }

    // 方面に応じて計算方法を変える
    if (vehicle.destination == Destination.toFujigaoka ||
        vehicle.destination == Destination.toAIT) {
      // 八草→藤が丘、大学方面
      for (var i = startIndex; i < stations.length - 1; i++) {
        final timePair = '${stations[i].id}-${stations[i + 1].id}';
        final time = int.parse(timesData[timePair] ?? '0');
        offset += time;
      }
    } else {
      // 藤が丘→八草方面
      for (var i = startIndex; i > 0; i--) {
        final timePair = '${stations[i - 1].id}-${stations[i].id}';
        final time = int.parse(timesData[timePair] ?? '0');
        offset += time;
      }
    }
    return offset;
  }

  // 次の発車時刻の取得
  List<DepartureSchedule> searchNextDeparture({required int order}) {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextDepartureList = <DepartureSchedule>[];

    var counter = 0;
    final daiyaA = getDaiyaAlphabet();
    if (daiyaA == null) {
      return nextDepartureList;
    }
    final todayDaiya = getStationDaiyas(daiyaA: daiyaA);
    final timeOffset = calculateTimeOffset();

    final hours = todayDaiya.keys;
    final arrivalTime =
        stationAmongTimes[vehicle.vehicle]![vehicle.destination]!
                .values
                .map(int.parse)
                .fold(0, (a, b) => a + b) -
            timeOffset;

    for (final hour in hours) {
      final minutes = todayDaiya[hour];
      if (hour >= now.hour && minutes != null) {
        for (final minute in minutes) {
          if (minute > now.minute || hour > now.hour) {
            if (order == counter) {
              return nextDepartureList;
            } else {
              final baseTime = DateTime.utc(
                now.year,
                now.month,
                now.day,
                hour,
                minute,
              );
              nextDepartureList.add(
                DepartureSchedule(
                  departureTime: baseTime,
                  arrivalTime: baseTime.add(Duration(minutes: arrivalTime)),
                  offset: timeOffset,
                ),
              );
              counter++;
            }
          }
        }
      }
    }

    return nextDepartureList;
  }

  // 駅ごとのダイヤを取得
  Map<int, List<int>> getStationDaiyas({required String daiyaA}) {
    final baseDaiyas = daiya[vehicle.vehicle]![vehicle.destination]![daiyaA]!;
    if (vehicle.vehicle != Vehicles.linimo) {
      return baseDaiyas;
    }

    // 駅間の所要時間を計算
    var totalMinutes = 0;
    final stations = vehicle.stations;
    final startStationId =
        vehicle.destination == Destination.toFujigaoka ? 'L09' : 'L01';
    var currentId = startStationId;

    while (currentId != fromStation.id) {
      final nextIndex = stations.indexWhere((s) => s.id == currentId) +
          (vehicle.destination == Destination.toFujigaoka ? -1 : 1);
      if (nextIndex < 0 || nextIndex >= stations.length) {
        break;
      }

      final nextId = stations[nextIndex].id;
      final timeKey = '$currentId-$nextId';
      final reverseTimeKey = '$nextId-$currentId';

      final time = int.tryParse(
            stationAmongTimes[vehicle.vehicle]![vehicle.destination]![
                    timeKey] ??
                stationAmongTimes[vehicle.vehicle]![vehicle.destination]![
                    reverseTimeKey] ??
                '0',
          ) ??
          0;

      totalMinutes += time;
      currentId = nextId;
    }

    // 時刻表を調整
    final adjustedDaiyas = <int, List<int>>{};
    for (final hour in baseDaiyas.keys) {
      final adjustedMinutes = baseDaiyas[hour]!.map((minute) {
        final adjustedTime = minute + totalMinutes;
        final newHour = hour + (adjustedTime ~/ 60);
        final newMinute = adjustedTime % 60;

        if (!adjustedDaiyas.containsKey(newHour)) {
          adjustedDaiyas[newHour] = [];
        }
        return MapEntry(newHour, newMinute);
      });

      for (final entry in adjustedMinutes) {
        adjustedDaiyas[entry.key] ??= [];
        adjustedDaiyas[entry.key]!.add(entry.value);
      }
    }

    // 各時間の分を昇順にソート
    for (final hour in adjustedDaiyas.keys) {
      adjustedDaiyas[hour]!.sort();
    }

    return Map.fromEntries(
      adjustedDaiyas.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}
