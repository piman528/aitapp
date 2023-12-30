import 'dart:io';

import 'package:aitapp/const.dart';
import 'package:aitapp/models/get_syllabus.dart';
import 'package:aitapp/wighets/syllabus_item.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyllabusSearchList extends HookWidget {
  const SyllabusSearchList({
    super.key,
    this.dayOfWeek,
    this.classPeriod,
    this.searchText,
  });
  final DayOfWeek? dayOfWeek;
  final int? classPeriod;
  final String? searchText;

  @override
  Widget build(BuildContext context) {
    final getSyllabus = useRef(GetSyllabus());
    final operation = useRef<CancelableOperation<void>?>(null);
    final content = useState<Widget>(const SizedBox());

    Future<void> load() async {
      content.value = const Expanded(
        child: Center(
          child: SizedBox(
            height: 25, //指定
            width: 25, //指定
            child: CircularProgressIndicator(),
          ),
        ),
      );
      try {
        await getSyllabus.value.create();
        final list = await getSyllabus.value.getSyllabusList(
          dayOfWeek,
          classPeriod,
          searchText,
        );
        content.value = Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (c, i) => SyllabusItem(
              syllabus: list[i],
              getSyllabus: getSyllabus.value,
            ),
          ),
        );
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
        return () {
          operation.value!.cancel();
        };
      },
      [],
    );
    useEffect(
      () {
        operation.value = CancelableOperation.fromFuture(load());
        return () {};
      },
      [searchText],
    );

    return content.value;
  }
}
