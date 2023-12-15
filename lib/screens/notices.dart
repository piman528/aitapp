import 'package:aitapp/models/get_notice.dart';
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
  final univController = TextEditingController();
  final classController = TextEditingController();

  String univFilter = '';
  String classFilter = '';
  final getUnivNotice = GetNotice();
  final getClassNotice = GetNotice();

  void _printUnivFilterValue1() {
    setState(() {
      univFilter = univController.text;
    });
  }

  void _setClassFilterValue2() {
    setState(() {
      classFilter = classController.text;
    });
  }

  @override
  void initState() {
    univController.addListener(_printUnivFilterValue1);
    classController.addListener(_setClassFilterValue2);
    super.initState();
  }

  @override
  void dispose() {
    univController.dispose();
    classController.dispose();
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
                  controller: univController,
                  hintText: '送信元、キーワードで検索',
                ),
                UnivNoticeList(
                  getNotice: getUnivNotice,
                  filterText: univFilter,
                ),
              ],
            ),
            Column(
              children: [
                SearchBarWidget(
                  controller: classController,
                  hintText: '送信元、キーワードで検索',
                ),
                ClassNoticeList(
                  getNotice: getClassNotice,
                  filterText: classFilter,
                ),
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
