import 'dart:async';

import 'package:aitapp/domain/types/departure_schedule.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/presentation/screens/single_timetable_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class TimTableCard extends HookWidget {
  const TimTableCard({
    super.key,
    required this.vehicle,
    required this.departureSchedule,
    required this.station,
  });
  final Vehicle vehicle;
  final DepartureSchedule departureSchedule;
  final Station station;

  @override
  Widget build(BuildContext context) {
    final f = useMemoized(() => DateFormat('HH:mm'));
    final time = useState<DateTime?>(null);
    final timer = useRef<Timer?>(null);

    useEffect(
      () {
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
    final remainTime =
        departureSchedule.departureTime.difference(time.value!) > Duration.zero
            ? departureSchedule.departureTime.difference(time.value!)
            : Duration.zero;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (ctx) => SingleTimeTableDetailScreen(
                vehicle: vehicle,
                departureTime: departureSchedule.departureTime,
                station: station,
              ),
            ),
          );
        },
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
                        vehicle.icon,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        f.format(departureSchedule.departureTime),
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
                      color: remainTime.inMinutes < 3
                          ? Colors.red.withValues(alpha: 0.1)
                          : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: remainTime.inHours < 1
                        ? Row(
                            children: [
                              SizedBox(
                                width: 35, // 固定幅を設定
                                child: Text(
                                  'あと',
                                  textAlign: TextAlign.center, // 中央寄せ
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: remainTime.inMinutes < 3
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40, // 固定幅を設定
                                child: Text(
                                  '${remainTime.inMinutes % 60}分',
                                  textAlign: TextAlign.center, // 中央寄せ
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: remainTime.inMinutes < 3
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40, // 固定幅を設定
                                child: Text(
                                  '${remainTime.inSeconds % 60}秒',
                                  textAlign: TextAlign.center, // 中央寄せ
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: remainTime.inMinutes < 3
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            'あと1時間以上',
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value:
                    (1.0 - (remainTime.inSeconds / (30 * 60))).clamp(0.0, 1.0),
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                color: remainTime.inMinutes < 3
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // ignore: lines_longer_than_80_chars
                    '${vehicle.destination.displayName} 到着予定 ${f.format(departureSchedule.arrivalTime)}',
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
      ),
    );
  }
}
