import 'package:aitapp/application/config/const.dart';
import 'package:aitapp/application/state/setting_int_provider.dart';
import 'package:aitapp/domain/types/class.dart';
import 'package:aitapp/domain/types/class_period.dart';
import 'package:aitapp/domain/types/day_of_week.dart';

import 'package:aitapp/presentation/wighets/class_grid.dart';
import 'package:aitapp/presentation/wighets/class_time_view.dart';
import 'package:aitapp/presentation/wighets/week_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// 時間割
class TimeTable extends ConsumerWidget {
  const TimeTable({
    super.key,
    required this.classData,
  });
  final Map<DayOfWeek, Map<int, Class>> classData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingRow = ref.watch(settingIntProvider)!['classTimeTableRow']!;
    final timeFormat = DateFormat('HH:mm');
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(2),
                    height: 35,
                  ),
                  for (int i = 0; i < settingRow; i++) ...{
                    ClassTimeView(
                      start: timeFormat
                          .format(classPeriods[ClassPeriod.fromInt(i + 1)]![0]),
                      end: timeFormat
                          .format(classPeriods[ClassPeriod.fromInt(i + 1)]![1]),
                      number: i + 1,
                    ),
                  },
                ],
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Row(
                  children: [
                    for (final week in activeWeek) ...{
                      Expanded(
                        child: Column(
                          children: [
                            WeekGridContainer(
                              dayofweek: week,
                            ),
                            for (int i = 1; i <= settingRow; i++) ...{
                              ClassGridContainer(
                                dayOfWeek: week,
                                classPeriod: i,
                                clas: classData[week]?[i],
                              ),
                            },
                          ],
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Text(
                '今学期の取得単位：',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              Text(
                '14単位',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
