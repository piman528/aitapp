import 'package:aitapp/application/state/calendar_selected_date/selected_date.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/presentation/wighets/timeline_view/calendar_date.dart';
import 'package:aitapp/presentation/wighets/timeline_view/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SwipeableTimelineView extends HookConsumerWidget {
  const SwipeableTimelineView({
    super.key,
    required this.events,
  });

  final Map<DateTime, List<CalendarEvent>> events;

  static const int _initialPage = 3650; // 十分に大きな数値で中央からの移動を可能に
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useMemoized(() => ref.read(selectedDateProvider));
    final notifier = ref.read(selectedDateProvider.notifier);
    final pageController = usePageController(initialPage: _initialPage);

    DateTime getDateForPage(int page) {
      final difference = page - _initialPage;
      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ).add(Duration(days: difference));
    }

    return Column(
      children: [
        // 日付表示
        const CalendarDate(),
        // スワイプ可能なタイムライン
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (page) {
              final newDate = getDateForPage(page);
              notifier.select(newDate);
            },
            itemBuilder: (context, page) {
              return TimelineView(
                events: events,
                selectedDate: getDateForPage(page),
              );
            },
          ),
        ),
      ],
    );
  }
}
