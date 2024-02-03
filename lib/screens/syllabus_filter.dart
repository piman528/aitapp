import 'package:aitapp/const.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/syllabus_filtered_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyllabusFilterScreen extends HookWidget {
  const SyllabusFilterScreen({
    super.key,
    required this.dayOfWeek,
    required this.classPeriod,
    this.teacher,
  });

  final DayOfWeek dayOfWeek;
  final int classPeriod;
  final String? teacher;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final filter = useState('');

    useEffect(
      () {
        controller
          ..addListener(() {
            filter.value = controller.text;
          })
          ..text = teacher ?? '';
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${dayOfWeekToString[dayOfWeek]} $classPeriod限から検索',
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: controller,
            hintText: '教授名、授業名で検索',
          ),
          SyllabusList(
            classPeriod: classPeriod,
            dayOfWeek: dayOfWeek,
            filterText: filter.value,
          ),
        ],
      ),
    );
  }
}
