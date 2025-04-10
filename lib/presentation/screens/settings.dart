import 'package:aitapp/application/state/schedule/schedule.dart';
import 'package:aitapp/application/state/setting_int_provider.dart';
import 'package:aitapp/infrastructure/database/event_database.dart';
import 'package:aitapp/infrastructure/database/timetable_database.dart';
import 'package:aitapp/presentation/screens/license.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          '設定',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('ライセンス表示'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => const LicenseScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('時間割の表示行数'),
            trailing: DropdownButton(
              value: ref.watch(settingIntProvider)!['classTimeTableRow'],
              items: [
                5,
                6,
                7,
              ].map((number) {
                return DropdownMenuItem<int>(
                  value: number,
                  child: Text('$number'),
                );
              }).toList(),
              onChanged: (number) {
                ref
                    .read(settingIntProvider.notifier)
                    .changeNum('classTimeTableRow', number!);
              },
            ),
          ),
          ListTile(
            title: const Text('テーマ'),
            trailing: DropdownButton(
              value: ref.watch(settingIntProvider)!['colorTheme'],
              items: [
                'システムのデフォルト',
                'ライト',
                'ダーク',
              ].asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (number) {
                ref
                    .read(settingIntProvider.notifier)
                    .changeNum('colorTheme', number!);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('スケジュールの更新'),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('スケジュールの更新'),
                    content: const Text('サーバーからスケジュールを取得しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(scheduleNotifierProvider.notifier)
                              .fetchData();
                          Navigator.of(context).pop();
                        },
                        child: const Text('更新'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('時間割データベースの削除'),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('時間割データベースの削除'),
                    content: const Text('時間割データベースを削除しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          TimetableDatabase.instance.deleteTimetable();
                          Navigator.of(context).pop();
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month), // カレンダーアイコンに変更
            title: const Text('スケジュールをカレンダーに登録'), // テキストを変更
            onTap: () {
              ref
                  .read(scheduleNotifierProvider.notifier)
                  .addEventsToDeviceCalendar(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('予定データベースの削除'),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('予定データベースの削除'),
                    content: const Text(
                      '予定データベースを削除しますか？\n※サーバーから再取得するまで予定は表示されません',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          EventDatabase.instance.deleteAllEvents();
                          Navigator.of(context).pop();
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
