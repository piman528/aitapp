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
    required this.tap,
  });

  final ClassNotice notice;
  final int index;
  final GetNotice getNotice;
  final bool tap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (tap) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => ClassNoticeDetailScreen(
                    index: index,
                    getNotice: getNotice,
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notice.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(notice.content),
                const SizedBox(
                  height: 30,
                ),
                Text(notice.subject),
                const SizedBox(
                  height: 10,
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
