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
    required this.tap,
  });

  final UnivNotice notice;
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
                  builder: (ctx) => UnivNoticeDetailScreen(
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                ),
                // Text(notice.content),
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
                      notice.sendAt,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
