import 'dart:io';

import 'package:aitapp/const.dart';
import 'package:aitapp/models/class.dart';
import 'package:aitapp/provider/class_timetable_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/setting_int_provider.dart';
import 'package:aitapp/screens/syllabus_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 授業時間表示
class ClassTime extends StatelessWidget {
  const ClassTime({
    super.key,
    required this.start,
    required this.end,
    required this.number,
  });
  final String start;
  final String end;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      margin: const EdgeInsets.all(2),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            start,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.grey,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(
              '$number',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          Text(
            end,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// 曜日表示
class WeekGridContainer extends StatelessWidget {
  const WeekGridContainer({super.key, required this.dayofweek});
  final String dayofweek;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      margin: const EdgeInsets.all(2),
      height: 35,
      child: Text(
        dayofweek,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

// 授業
class ClassGridContainer extends StatelessWidget {
  const ClassGridContainer({
    required this.dayOfWeek,
    required this.classPeriod,
    this.clas,
    super.key,
  });

  final DayOfWeek dayOfWeek;
  final int classPeriod;
  final Class? clas;

  String alphanumericToHalfLength(String input) {
    return input.replaceAllMapped(RegExp(r'[^\x00-\x7F]'), (match) {
      return String.fromCharCode(match.group(0)!.codeUnitAt(0) - 0xfee0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (ctx) => SyllabusFilterScreen(
              dayOfWeek: dayOfWeek,
              classPeriod: classPeriod,
              teacher: clas?.teacher,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: clas != null
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.primaryContainer,
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(2),
        height: 82,
        padding: const EdgeInsets.all(4),
        alignment: Alignment.topCenter,
        child: clas != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    clas!.title,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    width: double.infinity - 5,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Text(
                      alphanumericToHalfLength(clas!.classRoom),
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

// 時間割
class TimeTable extends HookConsumerWidget {
  const TimeTable({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(classTimeTableProvider);
    final settingRow = ref.watch(settingIntProvider)!['classTimeTableRow']!;
    useEffect(
      () {
        if (asyncValue.isLoading || asyncValue.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final list = ref.read(idPasswordProvider);
            ref
                .read(classTimeTableProvider.notifier)
                .fetchData(list[0], list[1], ref);
          });
        }
        return null;
      },
      [],
    );
    return asyncValue.when(
      loading: () => const Center(
        child: SizedBox(
          height: 25, //指定
          width: 25, //指定
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, __) {
        if (error is SocketException) {
          return const Center(
            child: Text('インターネットに接続できません'),
          );
        } else {
          return Center(
            child: Text(error.toString()),
          );
        }
      },
      data: (data) => ListView(
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
                      ClassTime(
                        start: classPeriods[i][0],
                        end: classPeriods[i][1],
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
                                dayofweek: dayOfWeekToString[week]!,
                              ),
                              for (int i = 1; i <= settingRow; i++) ...{
                                ClassGridContainer(
                                  dayOfWeek: week,
                                  classPeriod: i,
                                  clas: data[week]?[i],
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
        ],
      ),
    );
  }
}
