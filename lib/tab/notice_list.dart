import 'package:aitapp/router.dart';
import 'package:aitapp/wighet/search_bar.dart';
import 'package:flutter/material.dart';

class Notice {
  Notice(this.sender, this.title, this.content, this.sendAt);
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 内容
  final String content;
  // 送信日時
  final String sendAt;
}

final models = [
  Notice(
    'こんにちは',
    'テストテストテストテストテストテストテストテストテスト',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'こんにちは',
    'テストテストテストテストテストテストテストテストテストテストテストテスト',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/10/24',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
  Notice(
    'yohei',
    'こんにちは',
    'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
    '2023/11/03',
  ),
];

Widget modelToWidget(Notice model, BuildContext context) {
  final title = Container(
    // color: Colors.purple[200],
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
    alignment: Alignment.centerLeft,
    child: Text(
      model.title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
  final content = Container(
    // color: Colors.green[200],
    padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
    alignment: Alignment.centerLeft,
    child: Text(model.content),
  );
  final sender = Container(
    // color: Colors.red[200],
    padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(model.sender), Text(model.sendAt)],
    ),
  );
  return GestureDetector(
    onTap: () {
      CustomNavigationHelper.router.push(
        CustomNavigationHelper.noticeDetailPath,
      );
    },
    child: Container(
      // color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title,
          content,
          sender,
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    ),
  );
}

class NoticeList extends StatelessWidget {
  const NoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: models.length,
      itemBuilder: (c, i) => modelToWidget(models[i], context),
    );
    final tabScreen = Column(
      children: [
        SearchBarWidget(
          controller: TextEditingController(),
          hintText: '送信元、キーワードで検索',
        ),
        Expanded(child: list)
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [tabScreen, tabScreen]),
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'お知らせ',
            // style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: '学内',
              ),
              Tab(
                text: '授業',
              ),
            ],
            labelColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
