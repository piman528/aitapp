import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/presentation/wighets/search_bar.dart';
import 'package:aitapp/presentation/wighets/syllabus_filtered_list.dart';
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
          '${dayOfWeek.displayName} $classPeriod限から検索',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
