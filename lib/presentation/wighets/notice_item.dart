import 'package:aitapp/application/state/notice_load/notice_load.dart';
import 'package:aitapp/domain/types/class_notice.dart';
import 'package:aitapp/domain/types/notice.dart';
import 'package:aitapp/domain/types/univ_notice.dart';
import 'package:aitapp/presentation/screens/notice_detail.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeItem extends ConsumerWidget {
  const NoticeItem({
    super.key,
    required this.notice,
    required this.isCommon,
    required this.page,
  });

  final Notice notice;
  final bool isCommon;
  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (!ref.read(noticeLoadNotifierProvider)) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) {
                    return NoticeDetailScreen(
                      index: notice.index,
                      isCommon: isCommon,
                      title: notice.title,
                      page: page,
                    );
                  },
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            height: isCommon ? 98 : 128,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    notice.isInportant
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                              horizontal: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                            ),
                            child: Text(
                              '重要',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color.fromARGB(
                                      255,
                                      240,
                                      247,
                                      255,
                                    ),
                                  ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40, // Adjust this value based on your font size
                        child: Text(
                          notice.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isCommon) ...{
                  const SizedBox(
                    height: 12,
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
                    height: 16,
                  ),
                  Text(
                    (notice as ClassNotice).subject,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
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
