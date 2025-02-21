import 'package:aitapp/application/state/schedule/schedule.dart';
import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/presentation/wighets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleAppbar extends ConsumerWidget {
  const ScheduleAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final notifier = ref.read(scheduleNotifierProvider.notifier);

    return AppBarWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Center(
          child: Row(
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: 110,
                child: Text(
                  '${scheduleState.showDate.year}年${scheduleState.showDate.month}月',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SegmentedButton<CalendarViewType>(
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: CalendarViewType.calendar,
                    icon: Icon(Icons.calendar_month, size: 20),
                  ),
                  ButtonSegment(
                    value: CalendarViewType.schedule,
                    icon: Icon(Icons.calendar_view_week, size: 20),
                  ),
                  ButtonSegment(
                    value: CalendarViewType.list,
                    icon: Icon(Icons.view_agenda, size: 20),
                  ),
                ],
                selected: {scheduleState.viewType},
                onSelectionChanged: (value) {
                  if (value.isNotEmpty) {
                    notifier.changeViewType(value.first);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
