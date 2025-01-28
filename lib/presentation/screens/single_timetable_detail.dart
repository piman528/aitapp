import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:flutter/material.dart';

class SingleTimeTableDetailScreen extends StatelessWidget {
  const SingleTimeTableDetailScreen({
    super.key,
    required this.vehicle,
    required this.departureTime,
    required this.offset,
  });
  final Vehicle vehicle;
  final DateTime departureTime;
  final int offset;

  String _calculateArrivalTime(DateTime baseTime, int addMinutes) {
    final arrivalTime = baseTime.add(Duration(minutes: addMinutes));
    return '${arrivalTime.hour}:${arrivalTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final stations = vehicle.stations;
    final timesData = stationAmongTimes[vehicle.vehicle]?[vehicle.destination];
    if (timesData == null) {
      return const Scaffold(
        body: Center(
          child: Text('時刻情報が見つかりません'),
        ),
      );
    }

    List<Station> orderedStations;
    if (vehicle.destination == Destination.toFujigaoka ||
        vehicle.destination == Destination.toAIT) {
      orderedStations = stations.reversed.toList();
    } else {
      orderedStations = stations;
    }

    var totalMinutes = 0;
    final stationSchedule = <Map<String, dynamic>>[];

    for (var i = 0; i < orderedStations.length; i++) {
      final currentStation = orderedStations[i];
      stationSchedule.add({
        'station': currentStation.name,
        'time': _calculateArrivalTime(
          departureTime.subtract(Duration(minutes: offset)),
          totalMinutes,
        ),
      });

      if (i < orderedStations.length - 1) {
        final nextStation = orderedStations[i + 1];
        var timePair = '${currentStation.id}-${nextStation.id}';
        if (vehicle.destination == Destination.toFujigaoka ||
            vehicle.destination == Destination.toAIT) {
          timePair = '${nextStation.id}-${currentStation.id}';
        }
        final travelTime = timesData[timePair];
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
              vehicle.icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '${vehicle.vehicle.displayName} (${vehicle.destination.displayName})',
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
