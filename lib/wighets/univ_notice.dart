import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/screens/univ_notice_detail.dart';
import 'package:flutter/material.dart';

class UnivNoticeItem extends StatelessWidget {
  const UnivNoticeItem({
    super.key,
    required this.notice,
    required this.index,
    required this.getNotice,
  });

  final UnivNotice notice;
  final int index;
  final GetNotice getNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => UnivNoticeDetailScreen(
                  index: index,
                  getNotice: getNotice,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(notice.content),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(notice.sender), Text(notice.sendAt)],
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Theme.of(context).hoverColor,
        ),
      ],
    );
  }
}
