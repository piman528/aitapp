import 'dart:async';
import 'package:aitapp/domain/features/next_departure.dart';
import 'package:aitapp/domain/types/departur_schedule.dart';
import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/presentation/screens/timetable_detail.dart';
import 'package:aitapp/presentation/wighets/timetable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimeTableColumn extends HookWidget {
  const TimeTableColumn({
    super.key,
    required this.vehicle,
  });
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final departureTimes = useState<List<DepartureSchedule>>([]);
    final timer = useRef<Timer?>(null);
    final selectedStation = useState<String?>(null);
    final mounted = useRef(true);

    // リニモの場合は駅一覧を取得
    final stations = useMemoized(
      () {
        if (vehicle.name == 'linimo') {
          final stationsData = vehicle.stations
              .asMap()
              .map((key, value) => MapEntry(value.id, value.name));

          // 終点駅を除外
          final endStation =
              vehicle.destination == Destination.toFujigaoka ? 'L01' : 'L09';
          final stations = stationsData.entries
              .where((entry) => entry.key != endStation)
              .toList();

          // 方面に応じて駅の並び順を調整
          if (vehicle.destination == Destination.toFujigaoka) {
            // 八草→藤が丘方面：L09から順に並べる
            stations.sort((a, b) => b.key.compareTo(a.key));
          } else {
            // 藤が丘→八草方面：L01から順に並べる
            stations.sort((a, b) => a.key.compareTo(b.key));
          }
          return stations;
        }
        return <MapEntry<String, String>>[];
      },
      [vehicle],
    );

    // 初期選択駅を設定
    useEffect(
      () {
        if (vehicle.name == 'linimo' && stations.isNotEmpty) {
          selectedStation.value = stations.first.key;
        }
        return null;
      },
      [vehicle, stations],
    );

    void refreshTime() {
      if (!mounted.value) {
        return;
      }
      final times = NextDeparture(
        vehicle: vehicle,
        order: 6,
        fromStation: selectedStation.value,
      ).searchNextDeparture();
      if (mounted.value) {
        departureTimes.value = times;
      }
    }

    useEffect(
      () {
        mounted.value = true;
        refreshTime();
        timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted.value) {
            timer.cancel();
            return;
          }
          final time = DateTime.now().toUtc().add(const Duration(hours: 9));
          if (departureTimes.value.isNotEmpty &&
              departureTimes.value[0].departureTime.difference(time).inSeconds <
                  0) {
            refreshTime();
          }
        });
        return () {
          mounted.value = false;
          timer.value?.cancel();
        };
      },
      const [],
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              if (vehicle.name == 'linimo' && stations.isNotEmpty) ...[
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    const Icon(Icons.train_outlined, size: 32),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedStation.value,
                        decoration: InputDecoration(
                          labelText: '出発駅',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: stations.map((station) {
                          return DropdownMenuItem(
                            value: station.key,
                            child: Text(station.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null && value != selectedStation.value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              selectedStation.value = value;
                              refreshTime();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
              Row(
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
                      departureTime: departureTimes.value[index].departureTime,
                      arrivalTime: departureTimes.value[index].arrivalTime,
                      offset: departureTimes.value[index].offset,
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
