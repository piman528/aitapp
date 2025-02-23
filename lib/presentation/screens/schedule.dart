import 'package:aitapp/application/state/calendar_selected_date/selected_date.dart';
import 'package:aitapp/application/state/schedule/schedule.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/presentation/wighets/custom_calendar.dart';
import 'package:aitapp/presentation/wighets/event_list_view.dart';
import 'package:aitapp/presentation/wighets/schedule_appbar.dart';
import 'package:aitapp/presentation/wighets/two_day_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(
      scheduleNotifierProvider.select((state) => state.events),
    );
    final scheduletype =
        ref.watch(scheduleNotifierProvider.select((state) => state.viewType));
    final notifier = ref.read(scheduleNotifierProvider.notifier);
    final selectedDate = ref.watch(selectedDateProvider);

    return Column(
      children: [
        const ScheduleAppbar(),
        Expanded(
          child: Row(
            children: [
              if (scheduletype == CalendarViewType.calendar) ...{
                Expanded(
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          _WeekdayLabel('日'),
                          _WeekdayLabel('月'),
                          _WeekdayLabel('火'),
                          _WeekdayLabel('水'),
                          _WeekdayLabel('木'),
                          _WeekdayLabel('金'),
                          _WeekdayLabel('土'),
                        ],
                      ),
                      Expanded(
                        child: CustomCalendar(
                          initialShowDate:
                              ref.read(scheduleNotifierProvider).showDate,
                          events: scheduleState.when(
                            data: (events) => events,
                            loading: () => const {},
                            error: (e, stack) => const {},
                          ),
                          onDateChanged: notifier.changeShowDate,
                        ),
                      ),
                    ],
                  ),
                ),
              },
              if (scheduletype == CalendarViewType.schedule) ...{
                Expanded(
                  child: TwoDaySchedule(
                    selectedDate: selectedDate,
                    events: scheduleState.when(
                      data: (events) => events,
                      loading: () => const {},
                      error: (e, stack) => const {},
                    ),
                  ),
                ),
              },
              if (scheduletype == CalendarViewType.list) ...{
                Expanded(
                  child: EventListView(
                    events: scheduleState.when(
                      data: (events) => events,
                      loading: () => const {},
                      error: (e, stack) => const {},
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: label == '日'
                ? Colors.red
                : label == '土'
                    ? Colors.blue
                    : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
