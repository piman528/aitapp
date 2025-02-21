import 'package:aitapp/application/state/calendar_selected_date/selected_date.dart';
import 'package:aitapp/application/state/selected_date_Logic_family/selected_date.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarCell extends ConsumerWidget {
  const CalendarCell({
    super.key,
    required this.date,
    required this.events,
    required this.isToday,
  });

  final DateTime date;
  final List<CalendarEvent> events;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedFamilyProvider(date));
    final notifier = ref.read(selectedDateProvider.notifier);
    return InkWell(
      onTap: () {
        notifier.select(date);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              color: isToday
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: date.weekday == DateTime.sunday
                      ? Colors.red
                      : date.weekday == DateTime.saturday
                          ? Colors.blue
                          : Colors.black,
                  fontWeight: isSelected || isToday ? FontWeight.bold : null,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: events.take(4).map((event) {
                  return Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      event.title,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
