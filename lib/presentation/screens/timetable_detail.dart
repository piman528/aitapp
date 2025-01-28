import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTableDetailScreen extends StatelessWidget {
  const TimeTableDetailScreen({
    super.key,
    required this.vehicle,
  });
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final vehicleName = vehicle.displayName;
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final todayDaiya = dayDaiya[DateFormat('yyyy-MM-dd').format(now)];
    int? initialValue;
    switch (todayDaiya) {
      case 'A':
        initialValue = 0;
      case 'B':
        initialValue = 1;
      case 'C':
        initialValue = 2;
    }
    return DefaultTabController(
      initialIndex: initialValue ?? 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                vehicle.icon,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '$vehicleName (${vehicle.destination.displayName})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          bottom: TabBar(
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ダイヤA',
                      style: TextStyle(
                        color: todayDaiya == 'A'
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (todayDaiya == 'A') ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '今日',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ダイヤB',
                      style: TextStyle(
                        color: todayDaiya == 'B'
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (todayDaiya == 'B') ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '今日',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ダイヤC',
                      style: TextStyle(
                        color: todayDaiya == 'C'
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    if (todayDaiya == 'C') ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '今日',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: ['A', 'B', 'C']
              .map(
                (daiya) => DaiyaDetail(
                  daiyaA: daiya,
                  vehicle: vehicle,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class DaiyaDetail extends StatelessWidget {
  const DaiyaDetail({
    super.key,
    required this.vehicle,
    required this.daiyaA,
  });
  final Vehicle vehicle;
  final String daiyaA;

  @override
  Widget build(BuildContext context) {
    final daiyas = daiya[vehicle.name]![vehicle.destination]![daiyaA]!;
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final currentHour = now.hour;
    final currentMinute = now.minute;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
                  spacing: 16,
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
