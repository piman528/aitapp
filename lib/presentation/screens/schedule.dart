import 'package:aitapp/application/state/schedule/schedule.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:aitapp/presentation/wighets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends HookConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final notifier = ref.read(scheduleNotifierProvider.notifier);

    return Column(
      children: [
        AppBarWidget(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(0.4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      scheduleState.whenData(
                        (data) {
                          notifier.changeFocusedDay(
                            DateTime(
                              data.forcusedDay.year,
                              data.forcusedDay.month - 1,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      scheduleState.when(
                        data: (data) => Text(
                          '${data.forcusedDay.year}年${data.forcusedDay.month}月',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        loading: SizedBox.new,
                        error: (error, stack) => const SizedBox(),
                      ),
                    ],
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      scheduleState.whenData(
                        (data) {
                          notifier.changeFocusedDay(
                            DateTime(
                              data.forcusedDay.year,
                              data.forcusedDay.month + 1,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: scheduleState.when(
            data: (data) => _buildCalendar(context, notifier, data),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('スケジュールの読み込みに失敗しました'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: notifier.fetchData,
                    child: const Text('再試行'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    List<UnivEvent> events,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.symmetric(
        vertical: 1,
        horizontal: 1,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${day.day}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          if (events.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.event,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    ScheduleNotifier notifier,
    CalendarState state,
  ) {
    useEffect(
      () {
        initializeDateFormatting();
        return null;
      },
      [],
    );
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<UnivEvent>(
            locale: 'ja_JP',
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: state.forcusedDay,
            onPageChanged: (focusDay) {
              notifier.changeFocusedDay(focusDay);
            },
            headerVisible: false,
            daysOfWeekHeight: 32,
            availableCalendarFormats: const {
              CalendarFormat.month: '月',
            },
            eventLoader: notifier.getEventsForSelectedDay,
            rowHeight: 100,
            onDaySelected: (selected, focused) {
              final events = notifier.getEventsForSelectedDay(selected);
              if (events.isNotEmpty) {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.6,
                    minChildSize: 0.4,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selected.month}月${selected.day}日の予定',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.event,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (event.period != null)
                                          Text('${event.period?.num}限'),
                                        if (event.location != null)
                                          Text('場所: ${event.location}'),
                                        if (event.teacher != null)
                                          Text('担当: ${event.teacher}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              weekendStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            calendarStyle: CalendarStyle(
              markersMaxCount: 0,
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders<UnivEvent>(
              dowBuilder: (context, day) {
                final weekdayString =
                    const ['月', '火', '水', '木', '金', '土', '日'][day.weekday - 1];
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(1),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.4),
                  ),
                  child: Text(
                    weekdayString,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: day.weekday == 7
                          ? Theme.of(context).colorScheme.error
                          : day.weekday == 6
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.8)
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                final events = notifier.getEventsForSelectedDay(day);
                return _buildDayCell(context, day, events);
              },
              selectedBuilder: (context, day, focusedDay) {
                final events = notifier.getEventsForSelectedDay(day);
                return _buildDayCell(context, day, events);
              },
              todayBuilder: (context, day, focusedDay) {
                final events = notifier.getEventsForSelectedDay(day);
                return _buildDayCell(context, day, events);
              },
              outsideBuilder: (context, day, focusedDay) {
                final events = notifier.getEventsForSelectedDay(day);
                return _buildDayCell(context, day, events);
              },
            ),
          ),
        ],
      ),
    );
  }
}
