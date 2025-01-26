import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/presentation/screens/timetable_detail.dart';
import 'package:aitapp/presentation/wighets/timetable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class TimeTableColumn extends HookWidget {
  const TimeTableColumn({
    super.key,
    required this.vehicle,
    required this.destination,
  });
  final String vehicle;
  final String destination;

  @override
  Widget build(BuildContext context) {
    final now =
        useMemoized(() => DateTime.now().toUtc().add(const Duration(hours: 9)));
    final todayDaiya = useMemoized(
      () => dayDaiya[DateFormat('yyyy-MM-dd').format(now)],
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '次の${todayDaiya != null && todayDaiya != '-' ? "3便" : "0便"}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (ctx) => TimeTableDetailScreen(
                        vehicle: vehicle,
                        destination: destination,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('時刻表を見る'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        todayDaiya != null && todayDaiya != '-'
            ? Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TimeCard(
                      vehicle: vehicle,
                      destination: destination,
                      order: index,
                    ),
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_transfer,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '本日の運行は終了しました',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
