import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/wighets/class_notice_listview.dart';
import 'package:aitapp/wighets/univ_notice_listview.dart';
import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final getUnivNotice = GetNotice();
  final getClassNotice = GetNotice();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '学内'),
              Tab(text: '授業'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                UnivNoticeList(
                  getNotice: getUnivNotice,
                ),
                ClassNoticeList(
                  getNotice: getClassNotice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
