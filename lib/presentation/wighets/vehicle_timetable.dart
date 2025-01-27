import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/presentation/wighets/vehicle_timetable_column.dart';
import 'package:flutter/material.dart';

class VehicleTimeTable extends StatelessWidget {
  const VehicleTimeTable({
    super.key,
    required this.vehicle,
  });

  final String vehicle;

  /// 行先情報を取得するヘルパーメソッド
  Map<String, String> _getDestination(int index) {
    final destinations = List<Map<String, String>>.from(
      (vehicles[vehicle]?['destinations'] as Map<String, String>).entries.map(
            (e) => {e.key: e.value},
          ),
    );
    return destinations[index];
  }

  /// 行先のキーを取得するヘルパーメソッド
  String _getDestinationKey(int index) {
    return _getDestination(index).keys.first;
  }

  /// 行先の値を取得するヘルパーメソッド
  String _getDestinationValue(int index) {
    return _getDestination(index).values.first;
  }

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
                          _getDestinationValue(0),
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
                          _getDestinationValue(1),
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
                  vehicle: vehicle,
                  destination: _getDestinationKey(0),
                ),
                TimeTableColumn(
                  vehicle: vehicle,
                  destination: _getDestinationKey(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
