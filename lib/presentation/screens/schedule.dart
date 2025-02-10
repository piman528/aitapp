import 'package:aitapp/application/state/schedule/schedule.dart';
import 'package:aitapp/domain/types/event.dart';
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

    return scheduleState.when(
      data: (events) => _buildCalendar(context, notifier),
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
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    List<UnivEvent> events,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(
        vertical: 1,
        horizontal: 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${day.day}',
            style: const TextStyle(fontSize: 10),
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
                    child: Text(
                      event.event,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildCalendar(BuildContext context, ScheduleNotifier notifier) {
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
            focusedDay: DateTime.now(),
            availableCalendarFormats: const {
              CalendarFormat.month: '月',
            },
            eventLoader: notifier.getEventsForSelectedDay,
            rowHeight: 120,
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
            calendarStyle: const CalendarStyle(
              markersMaxCount: 0,
            ),
            calendarBuilders: CalendarBuilders(
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
