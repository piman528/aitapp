import 'package:aitapp/wighets/class_notice_listview.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/univ_notice_listview.dart';
import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  String filter1 = '';
  String filter2 = '';

  void _printLatestValue1() {
    setState(() {
      filter1 = myController1.text;
    });
  }

  void _printLatestValue2() {
    setState(() {
      filter2 = myController2.text;
    });
  }

  @override
  void initState() {
    myController1.addListener(_printLatestValue1);
    myController2.addListener(_printLatestValue2);
    super.initState();
  }

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            Column(
              children: [
                SearchBarWidget(
                  controller: myController1,
                  hintText: '送信元、キーワードで検索',
                ),
                UnivNoticeList(
                  filterText: filter1,
                ),
              ],
            ),
            Column(
              children: [
                SearchBarWidget(
                  controller: myController2,
                  hintText: '送信元、キーワードで検索',
                ),
                ClassNoticeList(),
              ],
            ),
          ],
        ),
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
