import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      // body: Column(children: [SwitchListTile(value: value, onChanged: (isCheck){})],),
    );
  }
}
