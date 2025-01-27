import 'dart:async';
import 'package:aitapp/domain/features/next_departure.dart';
import 'package:aitapp/presentation/screens/timetable_detail.dart';
import 'package:aitapp/presentation/wighets/timetable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final departureTimes = useState<List<DateTime>>([]);
    final timer = useRef<Timer?>(null);

    void reflashtime() {
      departureTimes.value = NextDeparture(
        vehicle: vehicle,
        destination: destination,
        order: 4,
      ).searchNextDeparture();
    }

    useEffect(
      () {
        reflashtime();
        timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
          final time = DateTime.now().toUtc().add(const Duration(hours: 9));
          if (departureTimes.value.isNotEmpty &&
              departureTimes.value[0].difference(time).inSeconds < 0) {
            reflashtime();
          }
        });
        return () {
          timer.value!.cancel();
        };
      },
      const [],
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
                    '次の${departureTimes.value.length}便',
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
        departureTimes.value.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: departureTimes.value.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TimTableCard(
                      vehicle: vehicle,
                      departureTime: departureTimes.value[index],
                    ),
                  ),
                ),
              )
            : Expanded(
                child: Center(
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
              ),
      ],
    );
  }
}
