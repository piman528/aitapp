import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/presentation/wighets/month_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CustomCalendar extends HookConsumerWidget {
  const CustomCalendar({
    super.key,
    required this.initialShowDate,
    required this.events,
    this.onDateChanged,
  });

  final DateTime initialShowDate;
  final Map<DateTime, List<CalendarEvent>> events;
  final void Function(DateTime)? onDateChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useMemoized(ItemScrollController.new);
    final itemPositionsListener = useMemoized(ItemPositionsListener.create);
    final position = useRef<int?>(null);

    final initialDate = useMemoized(() {
      final now = DateTime.now();
      return DateTime(now.year - 5); // 現在から5年前を開始点とする
    });

    final initialIndex = useMemoized(() {
      final startYear = initialDate.year;
      final startMonth = initialDate.month;
      final targetYear = initialShowDate.year;
      final targetMonth = initialShowDate.month;
      return (targetYear - startYear) * 12 + (targetMonth - startMonth);
    });

    DateTime calculateMonth(int index) {
      return DateTime(
        initialDate.year,
        initialDate.month + index,
      );
    }

    void listener() {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isEmpty) {
        return;
      }
      final firstIndex = positions.first.index;
      if (firstIndex != position.value) {
        position.value = firstIndex;
        onDateChanged!(calculateMonth(firstIndex));
      }
    }

    useEffect(() {
      itemPositionsListener.itemPositions.addListener(listener);
      return () => itemPositionsListener.itemPositions.removeListener(listener);
    });

    return ScrollablePositionedList.builder(
      itemPositionsListener: itemPositionsListener,
      itemScrollController: scrollController,
      initialScrollIndex: initialIndex,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (BuildContext context, int index) {
        final month = calculateMonth(index);
        return MonthCalendar(
          month: month,
          events: events,
        );
      },
      itemCount: 120,
    );
  }
}
