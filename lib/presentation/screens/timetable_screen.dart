import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/domain/types/vehicles.dart';
import 'package:aitapp/presentation/wighets/appbar.dart';
import 'package:aitapp/presentation/wighets/vehicle_timetable.dart';
import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          AppBarWidget(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.6),
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
                  borderRadius: BorderRadius.circular(16),
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
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bus, size: 18),
                        SizedBox(width: 4),
                        Text('シャトルバス'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.train, size: 18),
                        SizedBox(width: 4),
                        Text('リニモ'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                VehicleTimeTable(
                  vehicles: [
                    Vehicle(
                      icon: Icons.directions_bus,
                      vehicle: Vehicles.bus,
                      destination: Destination.toAIT,
                      stations: stations[Vehicles.bus]!,
                    ),
                    Vehicle(
                      icon: Icons.directions_bus,
                      vehicle: Vehicles.bus,
                      destination: Destination.toYakusa,
                      stations: stations[Vehicles.bus]!,
                    ),
                  ],
                ),
                VehicleTimeTable(
                  vehicles: [
                    Vehicle(
                      icon: Icons.train,
                      vehicle: Vehicles.linimo,
                      destination: Destination.toYakusa,
                      stations: stations[Vehicles.linimo]!,
                    ),
                    Vehicle(
                      icon: Icons.train,
                      vehicle: Vehicles.linimo,
                      destination: Destination.toFujigaoka,
                      stations: stations[Vehicles.linimo]!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
