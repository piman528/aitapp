import 'package:aitapp/presentation/wighets/vehicle_timetable.dart';
import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8, right: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Scaffold.of(context).openDrawer,
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.6),
                        ),
                        child: TabBar(
                          labelColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
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
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
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
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  VehicleTimeTable(
                    vehicle: 'bus',
                  ),
                  VehicleTimeTable(
                    vehicle: 'linimo',
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
