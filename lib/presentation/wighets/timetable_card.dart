import 'dart:async';

import 'package:aitapp/domain/features/next_departure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class TimeCard extends HookWidget {
  const TimeCard({
    super.key,
    required this.vehicle,
    required this.destination,
    required this.order,
  });
  final String vehicle;
  final String destination;
  final int order;

  @override
  Widget build(BuildContext context) {
    final f = useMemoized(() => DateFormat('HH:mm'));
    final nextDepartureTime = useState<DateTime?>(null);
    final time = useState<DateTime?>(null);
    final timer = useRef<Timer?>(null);

    void reflashtime() {
      nextDepartureTime.value = NextDeparture(
        vehicle: vehicle,
        destination: destination,
        order: order,
      ).searchNextDeparture();
    }

    useEffect(
      () {
        nextDepartureTime.value = NextDeparture(
          vehicle: vehicle,
          destination: destination,
          order: order,
        ).searchNextDeparture();
        time.value = DateTime.now().toUtc().add(const Duration(hours: 9));
        timer.value =
            Timer.periodic(const Duration(milliseconds: 1000), (timer) {
          time.value = DateTime.now().toUtc().add(const Duration(hours: 9));
        });
        return () {
          timer.value!.cancel();
        };
      },
    );
    if (nextDepartureTime.value != null) {
      final remainTime = nextDepartureTime.value!.difference(time.value!);
      if (remainTime.inSeconds % 60 == 0 && remainTime.inMinutes % 5 == 0) {
        reflashtime();
      }
      final remainHour =
          remainTime.inMinutes < 60 ? '' : '${remainTime.inHours}時間';
      final remainMinutes =
          remainTime.inSeconds < 60 ? '' : '${remainTime.inMinutes % 60}分';
      final remainSeconds = '${remainTime.inSeconds % 60}秒';
      final progressValue =
          1.0 - (remainTime.inSeconds / (30 * 60)); // 30分を最大値とする
      return Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_bus,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        f.format(nextDepartureTime.value!),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: remainTime.inMinutes <= 3
                          ? Colors.red.withOpacity(0.1)
                          : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'あと$remainHour$remainMinutes$remainSeconds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: remainTime.inMinutes <= 3
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progressValue.clamp(0.0, 1.0),
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                color: remainTime.inMinutes <= 3
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '到着予定 ${f.format(nextDepartureTime.value!.add(const Duration(minutes: 10)))}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '運行中',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
