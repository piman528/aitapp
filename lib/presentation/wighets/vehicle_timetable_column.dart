import 'dart:async';
import 'package:aitapp/domain/features/next_departure.dart';
import 'package:aitapp/domain/types/departure_schedule.dart';
import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/vehicle.dart';
import 'package:aitapp/domain/types/vehicles.dart';
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
    final selectedStation = useState<String>(
      vehicle.vehicle == Vehicles.linimo
          ? vehicle.destination == Destination.toFujigaoka
              ? 'L09'
              : 'L01'
          : vehicle.destination == Destination.toYakusa
              ? 'A01'
              : 'A02',
    );
    final mounted = useRef(true);

    // リニモの場合は駅一覧を取得
    final stations = useMemoized(
      () {
        if (vehicle.vehicle == Vehicles.linimo) {
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
        if (vehicle.vehicle == Vehicles.linimo && stations.isNotEmpty) {
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

    Widget buildStationInfo() {
      if (vehicle.vehicle == Vehicles.linimo && stations.isNotEmpty) {
        // リニモの場合：青文字のボタンで表示
        return TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            alignment: Alignment.centerLeft,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        final station = stations[index];
                        return ListTile(
                          leading: const Icon(Icons.train),
                          title: Text(station.value),
                          selected: station.key == selectedStation.value,
                          onTap: () {
                            Navigator.pop(context);
                            if (station.key != selectedStation.value) {
                              selectedStation.value = station.key;
                              refreshTime();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.train_outlined, size: 20),
          label: Text(
            '${stations.firstWhere((s) => s.key == selectedStation.value).value} 発',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        // シャトルバスの場合：通常のテキストで表示
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.directions_bus_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                vehicle.destination == Destination.toYakusa ? '大学 発' : '八草 発',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildStationInfo(),
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
                    label: const Text(
                      '時刻表を見る',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
