import 'dart:io';

import 'package:aitapp/const.dart';
import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/get_syllabus.dart';
import 'package:aitapp/wighets/syllabus_item.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyllabusList extends HookWidget {
  const SyllabusList({
    super.key,
    this.dayOfWeek,
    this.classPeriod,
    this.filterText,
    this.searchText,
  });
  final DayOfWeek? dayOfWeek;
  final int? classPeriod;
  final String? filterText;
  final String? searchText;

  @override
  Widget build(BuildContext context) {
    final getSyllabus = useMemoized(GetSyllabus.new);
    final operation = useRef<CancelableOperation<void>?>(null);
    final syllabusList = useState<List<ClassSyllabus>?>(null);
    final content = useState<Widget>(
      const Expanded(
        child: Center(
          child: SizedBox(
            height: 25, //指定
            width: 25, //指定
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    Future<void> load() async {
      try {
        final thisMonth = DateTime.now().month;
        await getSyllabus.create();
        final list = await getSyllabus.getSyllabusList(
          dayOfWeek: dayOfWeek,
          classPeriod: classPeriod,
          searchWord: searchText,
          year: getSyllabus.filters.year.values.first,
          semester: thisMonth >= 4 && thisMonth <= 8 ? '1' : '2',
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
