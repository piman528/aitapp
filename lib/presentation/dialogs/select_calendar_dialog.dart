import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class SelectCalendarDialog extends StatelessWidget {
  const SelectCalendarDialog({
    super.key,
    required this.calendars,
    required this.onSelect,
  });
  final List<Calendar> calendars;
  final ValueChanged<Calendar> onSelect;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('カレンダーを選択'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: calendars.map((calendar) {
            return ListTile(
              title: Text(calendar.name ?? 'Unknown Calendar'),
              subtitle: Text(calendar.isDefault == true ? 'デフォルトカレンダー' : ''),
              onTap: () {
                onSelect(calendar);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}
