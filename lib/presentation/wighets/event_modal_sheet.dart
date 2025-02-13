import 'package:aitapp/domain/types/calendar_state.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventModalSheet extends StatelessWidget {
  const EventModalSheet({super.key, required this.details, required this.data});

  final CalendarTapDetails details;
  final CalendarState data;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
              '${details.date?.month}月${details.date?.day}日の予定',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: data.events[details.date]?.length ?? 0,
                itemBuilder: (context, index) {
                  final event = data.events[details.date]?[index];
                  if (event == null) {
                    return const SizedBox();
                  }
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (event is UnivEvent) ...{
                            Text('${event.period?.num}限'),
                            Text('場所: ${event.location}'),
                            Text('担当: ${event.teacher}'),
                          }
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
    );
  }
}
