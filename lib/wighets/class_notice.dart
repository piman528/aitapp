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
            if (tap && getNotice.token != null) {
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notice.title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                // Text(notice.content),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  notice.subject,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  notice.sender,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
