import 'dart:io';

import 'package:aitapp/domain/features/get_syllabus.dart';
import 'package:aitapp/domain/types/class_syllabus.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/select_syllabus_filters.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:aitapp/presentation/wighets/loading/syllabus_loading.dart';
import 'package:aitapp/presentation/wighets/syllabus_item.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyllabusList extends HookWidget {
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
  Widget build(BuildContext context) {
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
        final thisMonth = DateTime.now().month;
        await getSyllabus.create();
        final list = await getSyllabus.getSyllabusList(
          selectSyllabusFilters: SelectSyllabusFilters(
            week: dayOfWeek,
            hour: classPeriod,
            year: getSyllabus.filters.year.values.first,
            semester: thisMonth >= 4 && thisMonth <= 8
                ? Semester.early
                : Semester.late,
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
