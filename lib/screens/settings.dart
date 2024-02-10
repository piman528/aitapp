import 'package:aitapp/provider/setting_int_provider.dart';
import 'package:aitapp/screens/license.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('設定'),
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
        ],
      ),
    );
  }
}
