import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/domain/types/vehicles.dart';
import 'package:aitapp/presentation/wighets/daiya_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTableDetailScreen extends StatelessWidget {
  const TimeTableDetailScreen({
    super.key,
    required this.vehicle,
    required this.selectedStation,
  });
  final Vehicle vehicle;
  final Station selectedStation;

  @override
  Widget build(BuildContext context) {
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
    final isLinimo = vehicle.vehicle == Vehicles.linimo;

    return DefaultTabController(
      initialIndex: initialValue ?? 0,
      length: isLinimo ? 2 : 3,
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
                '${vehicle.vehicle.displayName} (${vehicle.destination.displayName})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.6),
                ),
                child: TabBar(
                  labelColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  dividerColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  tabs: [
                    ...['A', 'B', if (!isLinimo) 'C'].map(
                      (daiyaType) => Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ダイヤ$daiyaType',
                            ),
                            if (todayDaiya == daiyaType) ...[
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  ...['A', 'B', if (!isLinimo) 'C'].map(
                    (daiya) => DaiyaDetail(
                      daiyaA: daiya,
                      vehicle: vehicle,
                      selectedStation: selectedStation,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
