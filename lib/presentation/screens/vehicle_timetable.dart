import 'package:aitapp/presentation/wighets/vehicle_timetable_item.dart';
import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 16, bottom: 16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 28,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        // color: Colors.black
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withOpacity(0.3),
                      ),
                      child: TabBar(
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
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
                          horizontal: 1,
                          vertical: 4,
                        ),
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.school, size: 18),
                                SizedBox(width: 4),
                                Text('愛工大行き'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_railway, size: 18),
                                SizedBox(width: 4),
                                Text('八草駅行き'),
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
            const Expanded(
              child: TabBarView(
                children: [
                  TimeTableColumn(
                    vehicle: 'bus',
                    destination: 'toAIT',
                  ),
                  TimeTableColumn(
                    vehicle: 'bus',
                    destination: 'toYakusa',
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
