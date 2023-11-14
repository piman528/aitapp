import 'package:aitapp/const.dart';
import 'package:aitapp/core/get_notice.dart';
import 'package:aitapp/router.dart';
import 'package:aitapp/wighet/search_bar.dart';
import 'package:flutter/material.dart';

class UnivNotice {
  UnivNotice(this.sender, this.title, this.content, this.sendAt);
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 内容
  final String content;
  // 送信日時
  final String sendAt;

  Widget modelToWidget(BuildContext context) {
    final widgetTitle = Container(
      // color: Colors.purple[200],
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    final widgetContent = Container(
      // color: Colors.green[200],
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      alignment: Alignment.centerLeft,
      child: Text(content),
    );
    final widgetSender = Container(
      // color: Colors.red[200],
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(sender), Text(sendAt)],
      ),
    );
    return GestureDetector(
      onTap: () async {
        await getUnivNoticelist();
        CustomNavigationHelper.router.push(
          CustomNavigationHelper.noticeDetailPath,
        );
      },
      child: Container(
        // color: Colors.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widgetTitle,
            widgetContent,
            widgetSender,
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class ClassNotice {
  ClassNotice(
    this.sender,
    this.title,
    this.content,
    this.sendAt,
    this.subject,
    this.makeupClassAt,
  );
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 内容
  final String content;
  // 送信日時
  final String sendAt;
  // 教科
  final String subject;
  // 補講日日付
  final String makeupClassAt;
  Widget modelToWidget(BuildContext context) {
    return Container();
  }
}

class NoticeList extends StatelessWidget {
  const NoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: models.length,
      itemBuilder: (c, i) => models[i].modelToWidget(context),
    );
    final tabScreen = Column(
      children: [
        SearchBarWidget(
          controller: TextEditingController(),
          hintText: '送信元、キーワードで検索',
        ),
        Expanded(child: list),
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
