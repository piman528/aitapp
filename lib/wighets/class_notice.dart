import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/screens/class_notice_detail.dart';
import 'package:flutter/material.dart';

class ClassNoticeItem extends StatelessWidget {
  const ClassNoticeItem({
    super.key,
    required this.notice,
    required this.index,
    required this.getNotice,
  });

  final ClassNotice notice;
  final int index;
  final GetNotice getNotice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ClassNoticeDetailScreen(
              index: index,
              getNotice: getNotice,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // color: Colors.purple[200],
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            alignment: Alignment.centerLeft,
            child: Text(
              notice.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // color: Colors.green[200],
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            alignment: Alignment.centerLeft,
            child: Text(notice.content),
          ),
          Container(
            // color: Colors.green[200],
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            alignment: Alignment.centerLeft,
            child: Text(notice.subject),
          ),
          Container(
            // color: Colors.red[200],
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(notice.sender), Text(notice.sendAt)],
            ),
          ),
          Divider(
            thickness: 2,
            color: Theme.of(context).hoverColor,
          ),
        ],
      ),
    );
  }
}
