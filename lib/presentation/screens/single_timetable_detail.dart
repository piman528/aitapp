import 'package:aitapp/application/config/const.dart';
import 'package:flutter/material.dart';

class SingleTimeTableDetailScreen extends StatelessWidget {
  const SingleTimeTableDetailScreen({
    super.key,
    required this.vehicle,
    required this.destination,
    required this.departureTime,
  });
  final String vehicle;
  final String destination;
  final DateTime departureTime;

  String _calculateArrivalTime(DateTime baseTime, int addMinutes) {
    final arrivalTime = baseTime.add(Duration(minutes: addMinutes));
    return '${arrivalTime.hour}:${arrivalTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final vehicleData = vehicles[vehicle];
    if (vehicleData == null) {
      return const Scaffold(
        body: Center(
          child: Text('車両情報が見つかりません'),
        ),
      );
    }

    final vehicleName = vehicleData['name'] as String;
    final destinations = vehicleData['destinations'] as Map<String, String>;
    final destinationName = destinations[destination] ?? '不明';
    final vehicleIcon = vehicleData['icon'] as IconData?;

    // リニモの場合
    if (vehicle == 'linimo') {
      final linimoData = vehicles['linimo'];
      if (linimoData == null) {
        return const Scaffold(
          body: Center(
            child: Text('リニモの情報が見つかりません'),
          ),
        );
      }

      final stationsData = linimoData['stations'];
      final timesData = linimoData['times'];
      if (stationsData == null || timesData == null) {
        return const Scaffold(
          body: Center(
            child: Text('駅・時刻情報が見つかりません'),
          ),
        );
      }

      final stations = (stationsData as Map<String, String>).entries.toList();
      final times = timesData as Map<String, String>;

      List<MapEntry<String, String>> orderedStations;
      if (destination == 'toFujigaoka') {
        orderedStations = stations.reversed.toList();
      } else {
        orderedStations = stations;
      }

      var totalMinutes = 0;
      final stationSchedule = <Map<String, dynamic>>[];

      for (var i = 0; i < orderedStations.length; i++) {
        final currentStation = orderedStations[i];
        stationSchedule.add({
          'station': currentStation.value,
          'time': _calculateArrivalTime(departureTime, totalMinutes),
        });

        if (i < orderedStations.length - 1) {
          final nextStation = orderedStations[i + 1];
          var timePair = '${currentStation.key}-${nextStation.key}';
          if (destination == 'toFujigaoka') {
            timePair = '${nextStation.key}-${currentStation.key}';
          }
          final travelTime = times[timePair];
          if (travelTime != null) {
            totalMinutes += int.parse(travelTime);
          }
          stationSchedule[i]['travelTime'] = travelTime ?? '---';
        }
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Row(
            children: [
              Icon(
                vehicleIcon ?? Icons.error,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '$vehicleName ($destinationName)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: stationSchedule.length,
          itemBuilder: (context, index) {
            final isFirst = index == 0;
            final isLast = index == stationSchedule.length - 1;
            final schedule = stationSchedule[index];

            return Column(
              children: [
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isFirst || isLast
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isFirst
                            ? Icons.departure_board
                            : isLast
                                ? Icons.location_on
                                : Icons.train,
                        color: isFirst || isLast
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      schedule['station'] as String,
                      style: TextStyle(
                        fontWeight: isFirst || isLast ? FontWeight.bold : null,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        schedule['time'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 24,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${schedule['travelTime']}分',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }
    // シャトルバスの場合
    else {
      final busStops = {
        'toAIT': ['八草駅', '愛知工業大学'],
        'toYakusa': ['愛知工業大学', '八草駅'],
      };

      final stops = busStops[destination];
      if (stops == null) {
        return const Scaffold(
          body: Center(
            child: Text('バス停情報が見つかりません'),
          ),
        );
      }

      const travelTime = 10;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Row(
            children: [
              Icon(
                vehicleIcon ?? Icons.error,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '$vehicleName ($destinationName)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: stops.length,
          itemBuilder: (context, index) {
            final isFirst = index == 0;
            final isLast = index == stops.length - 1;
            final arrivalTime = _calculateArrivalTime(
              departureTime,
              index * travelTime,
            );

            return Column(
              children: [
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isFirst || isLast
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isFirst
                            ? Icons.departure_board
                            : isLast
                                ? Icons.location_on
                                : Icons.directions_bus,
                        color: isFirst || isLast
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      stops[index],
                      style: TextStyle(
                        fontWeight: isFirst || isLast ? FontWeight.bold : null,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        arrivalTime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 24,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '約10分',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }
  }
}
