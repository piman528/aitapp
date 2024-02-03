import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/screens/notice_detail.dart';
import 'package:flutter/material.dart';

class NoticeItem extends StatelessWidget {
  const NoticeItem({
    super.key,
    required this.notice,
    required this.index,
    required this.getNotice,
    required this.tap,
    required this.isCommon,
  });

  final Notice notice;
  final int index;
  final GetNotice getNotice;
  final bool tap;
  final bool isCommon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (tap && getNotice.token != null) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) {
                    return NoticeDetailScreen(
                      index: index,
                      getNotice: getNotice,
                      isCommon: isCommon,
                    );
                  },
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
                if (isCommon) ...{
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notice.sender,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Text(
                        (notice as UnivNotice).sendAt,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                } else ...{
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    (notice as ClassNotice).subject,
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
                },
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
