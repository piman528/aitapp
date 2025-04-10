import 'package:aitapp/application/state/calendar_selected_date/selected_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarDate extends ConsumerWidget {
  const CalendarDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '${selectedDate.year}年${selectedDate.month}月${selectedDate.day}日',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
