import 'package:aitapp/wighets/class_notice_list.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/univ_notice_list.dart';
import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabScreenClass = Column(
      children: [
        SearchBarWidget(
          controller: TextEditingController(),
          hintText: '送信元、キーワードで検索',
        ),
        const ClassNoticeList(),
      ],
    );
    final tabScreenUniv = Column(
      children: [
        SearchBarWidget(
          controller: TextEditingController(),
          hintText: '送信元、キーワードで検索',
        ),
        const UnivNoticeList(),
      ],
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [tabScreenUniv, tabScreenClass]),
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
            // labelColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
