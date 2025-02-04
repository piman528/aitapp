import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NoticeLoadingWidget extends StatelessWidget {
  const NoticeLoadingWidget({super.key, required this.isCommon});

  final bool isCommon;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          expandedHeight: 80,
          snap: true,
          floating: true,
          flexibleSpace: Shimmer.fromColors(
            baseColor:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            highlightColor: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 48,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Shimmer.fromColors(
            baseColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.5),
            highlightColor: Theme.of(context).colorScheme.surface,
            child: Column(
              children: List.generate(
                10,
                (index) => Column(
                  children: [
                    Container(
                      height: isCommon ? 98 : 128,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  height: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isCommon) ...{
                            const SizedBox(
                              height: 34,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          } else ...{
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 200,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 100,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
