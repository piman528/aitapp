import 'dart:io';

import 'package:aitapp/application/state/class_timetable/class_timetable.dart';
import 'package:aitapp/presentation/wighets/class_timetable_item.dart';
import 'package:aitapp/presentation/wighets/loading/timetable_loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClassTimeTableScreen extends ConsumerWidget {
  const ClassTimeTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(classTimeTableNotifierProvider);
    return asyncValue.when(
      loading: () => const TimetableLoadingWidget(),
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
          const SizedBox(
            height: 60,
          ),
          Expanded(
            child: TimeTable(
              classData: data,
            ),
          ),
        ],
      ),
    );
  }
}
