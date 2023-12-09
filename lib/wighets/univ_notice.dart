import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/screens/univ_notice_detail.dart';
import 'package:flutter/material.dart';

class UnivNoticeItem extends StatelessWidget {
  const UnivNoticeItem({super.key, required this.notice, required this.index});

  final UnivNotice notice;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => UnivNoticeDetailScreen(
              index: index,
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
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            alignment: Alignment.centerLeft,
            child: Text(notice.content),
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
