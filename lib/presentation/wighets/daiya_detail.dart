import 'package:aitapp/domain/features/next_departure.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:flutter/material.dart';

class DaiyaDetail extends StatelessWidget {
  const DaiyaDetail({
    super.key,
    required this.vehicle,
    required this.daiyaA,
    required this.selectedStation,
  });
  final Vehicle vehicle;
  final String daiyaA;
  final Station selectedStation;

  @override
  Widget build(BuildContext context) {
    final daiyas = NextDeparture(vehicle: vehicle, fromStation: selectedStation)
        .getStationDaiyas(daiyaA: daiyaA);
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final currentHour = now.hour;
    final currentMinute = now.minute;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: daiyas.keys.length,
      itemBuilder: (context, index) {
        final hour = daiyas.keys.elementAt(index);
        final isCurrentHour = hour == currentHour;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: isCurrentHour ? 4 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrentHour
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: isCurrentHour
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$hour時',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCurrentHour
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 16,
                  children: [
                    for (final minutes in daiyas[hour]!)
                      Container(
                        width: 56,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentHour && minutes > currentMinute
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrentHour && minutes > currentMinute
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: isCurrentHour && minutes > currentMinute
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Text(
                          '$minutes分',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isCurrentHour && minutes > currentMinute
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrentHour && minutes > currentMinute
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
