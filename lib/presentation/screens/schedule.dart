import 'package:aitapp/application/state/schedule/schedule.dart';
import 'package:aitapp/domain/types/event_data_source.dart';
import 'package:aitapp/presentation/wighets/appbar.dart';
import 'package:aitapp/presentation/wighets/calendar_appointment.dart';
import 'package:aitapp/presentation/wighets/calendar_cell.dart';
import 'package:aitapp/presentation/wighets/event_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleScreen extends HookConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final notifier = ref.read(scheduleNotifierProvider.notifier);

    return Column(
      children: [
        AppBarWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 110,
                    child: scheduleState.when(
                      data: (data) => Text(
                        '${data.forcusedDay.year}年${data.forcusedDay.month}月',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SegmentedButton<CalendarView>(
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: CalendarView.month,
                        icon: Icon(Icons.calendar_month, size: 20),
                      ),
                      ButtonSegment(
                        value: CalendarView.week,
                        icon: Icon(Icons.calendar_view_week, size: 20),
                      ),
                      ButtonSegment(
                        value: CalendarView.schedule,
                        icon: Icon(Icons.view_agenda, size: 20),
                      ),
                    ],
                    selected: {
                      scheduleState.maybeWhen(
                        data: (data) => data.view,
                        orElse: () => CalendarView.month,
                      ),
                    },
                    onSelectionChanged: (value) {
                      if (value.isNotEmpty) {
                        notifier.changeView(value.first);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: scheduleState.when(
            data: (data) => SfCalendar(
              key: ValueKey(scheduleState.value?.view),
              view: data.view,
              initialDisplayDate: data.forcusedDay,
              viewHeaderHeight: 40,
              dataSource: EventDataSource(data.events),
              monthCellBuilder: (context, details) {
                final events = data.events[DateTime(
                      details.date.year,
                      details.date.month,
                      details.date.day,
                    )] ??
                    [];

                return CalendarCell(
                  details: details,
                  events: events,
                );
              },
              scheduleViewSettings: const ScheduleViewSettings(
                appointmentItemHeight: 70,
                hideEmptyScheduleWeek: true,
                monthHeaderSettings: MonthHeaderSettings(
                  height: 40,
                  textAlign: TextAlign.center,
                ),
              ),
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 7,
                // endHour: 24,
              ),
              appointmentBuilder: (context, calendarAppointmentDetails) {
                final appointment = calendarAppointmentDetails
                    .appointments.first as Appointment;
                return CalendarAppointment(appointment: appointment);
              },
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                navigationDirection: MonthNavigationDirection.vertical,
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(fontSize: 14),
                  trailingDatesTextStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                  leadingDatesTextStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              cellEndPadding: 0,
              onTap: (CalendarTapDetails details) {
                if (data.events[details.date] != null &&
                    data.events[details.date]!.isNotEmpty) {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => EventModalSheet(
                      details: details,
                      data: data,
                    ),
                  );
                }
              },
              headerHeight: 0,
              onViewChanged: (ViewChangedDetails details) {
                if (details.visibleDates.isNotEmpty) {
                  Future.microtask(() {
                    notifier.changeFocusedDay(
                      details.visibleDates[details.visibleDates.length ~/ 2],
                    );
                  });
                }
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
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
}
