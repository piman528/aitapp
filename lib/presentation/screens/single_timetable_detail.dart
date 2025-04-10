import 'package:aitapp/domain/features/next_departure.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleTimeTableDetailScreen extends StatelessWidget {
  const SingleTimeTableDetailScreen({
    super.key,
    required this.vehicle,
    required this.departureTime,
    required this.station,
  });
  final Vehicle vehicle;
  final DateTime departureTime;
  final Station station;

  @override
  Widget build(BuildContext context) {
    final stationSchedule =
        NextDeparture(vehicle: vehicle, fromStation: station).getSchedule(
      departureTime,
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              vehicle.icon,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              '${vehicle.vehicle.displayName} (${vehicle.destination.displayName})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
                    schedule.station.name,
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
                      DateFormat.Hm().format(schedule.time),
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
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${schedule.amongTime}分',
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
