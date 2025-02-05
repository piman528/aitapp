import 'dart:io';

import 'package:aitapp/application/state/class_timetable/class_timetable.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:aitapp/presentation/wighets/class_timetable_item.dart';
import 'package:aitapp/presentation/wighets/loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClassTimeTableScreen extends ConsumerWidget {
  const ClassTimeTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(classTimeTableNotifierProvider);
    final notifier = ref.read(classTimeTableNotifierProvider.notifier);

    return asyncValue.when(
      loading: () => const LoadingWidget(),
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
      data: (data) => Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                DropdownButton<int>(
                  items: data.timetable.keys
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e,
                          child: Text(
                            e.toString(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      value != null ? notifier.changeSelectYear(value) : null,
                  value: data.selectYear,
                ),
                DropdownButton<Semester>(
                  items: data.timetable[notifier.selectYear]?.keys
                      .map(
                        (e) => DropdownMenuItem<Semester>(
                          value: e,
                          child: Text(
                            e.displayName,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => value != null
                      ? notifier.changeSelectSemester(value)
                      : null,
                  value: data.selectSemester,
                ),
              ],
            ),
          ),
          Expanded(
            child: TimeTable(
              classData: notifier.selectClassData,
            ),
          ),
        ],
      ),
    );
  }
}
