import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/presentation/wighets/vehicle_timetable_column.dart';
import 'package:flutter/material.dart';

class VehicleTimeTable extends StatelessWidget {
  const VehicleTimeTable({
    super.key,
    required this.vehicles,
  });

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.6),
              ),
              child: TabBar(
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.all(2),
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_circle_up_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicles[0].destination.displayName}行き',
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_circle_down_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicles[1].destination.displayName}行き',
                        ),
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
                TimeTableColumn(
                  vehicle: vehicles[0],
                ),
                TimeTableColumn(
                  vehicle: vehicles[1],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
