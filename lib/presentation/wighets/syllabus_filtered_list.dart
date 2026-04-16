import 'dart:io';

import 'package:aitapp/application/state/class_timetable/class_timetable.dart';
import 'package:aitapp/domain/features/get_syllabus.dart';
import 'package:aitapp/domain/types/class_syllabus.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/select_syllabus_filters.dart';
import 'package:aitapp/presentation/wighets/loading/syllabus_loading.dart';
import 'package:aitapp/presentation/wighets/syllabus_item.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SyllabusList extends HookConsumerWidget {
  const SyllabusList({
    super.key,
    this.dayOfWeek,
    this.classPeriod,
    this.filterText,
  });
  final DayOfWeek? dayOfWeek;
  final int? classPeriod;
  final String? filterText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(classTimeTableNotifierProvider.notifier);
    final getSyllabus = useMemoized(GetSyllabus.new);
    final operation = useRef<CancelableOperation<void>?>(null);
    final syllabusList = useState<List<ClassSyllabus>?>(null);
    final content = useState<Widget>(
      const Expanded(
        child: SyllabusLoadingWidget(),
      ),
    );

    Future<void> load() async {
      try {
        await getSyllabus.create();
        final selectYear = notifier.selectYear;
        final yearKey = getSyllabus.filters.year.keys.firstWhere(
          (k) => k.startsWith('$selectYear'),
          orElse: () => '',
        );
        final yearValue = getSyllabus.filters.year[yearKey] ?? '';
        final list = await getSyllabus.getSyllabusList(
          selectSyllabusFilters: SelectSyllabusFilters(
            week: dayOfWeek,
            hour: classPeriod,
            year: yearValue,
            semester: notifier.selectSemester,
          ),
        );
        syllabusList.value = list;
      } on SocketException {
        content.value = const Center(
          child: Text('インターネットに接続できません'),
        );
      } on Exception catch (err) {
        content.value = Center(
          child: Text(err.toString()),
        );
      }
    }

    useEffect(
      () {
        operation.value = CancelableOperation.fromFuture(
          load(),
        );

        return () {
          operation.value!.cancel();
        };
      },
      [],
    );

    if (syllabusList.value != null) {
      late List<ClassSyllabus> result;
      if (filterText != null) {
        result = syllabusList.value!
            .where(
              (syllabus) =>
                  syllabus.teacher.toLowerCase().contains(filterText!) ||
                  syllabus.subject.toLowerCase().contains(filterText!),
            )
            .toList();
      } else {
        result = syllabusList.value!;
      }
      return Expanded(
        child: ListView.builder(
          itemCount: result.length,
          itemBuilder: (c, i) => SyllabusItem(
            syllabus: result[i],
            getSyllabus: getSyllabus,
          ),
        ),
      );
    }
    return content.value;
  }
}
