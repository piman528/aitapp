import 'package:aitapp/application/state/setting_int_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class TimetableLoadingWidget extends ConsumerWidget {
  const TimetableLoadingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingRow = ref.watch(settingIntProvider)!['classTimeTableRow']!;
    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.5),
            highlightColor: Theme.of(context).colorScheme.surface,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // 時限表示部分
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(2),
                            height: 35,
                          ),
                          for (int i = 0; i < settingRow; i++) ...{
                            Container(
                              height: 82,
                              margin: const EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                  ),
                                  Container(
                                    height: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          },
                        ],
                      ),
                      const SizedBox(width: 4),
                      // 曜日と授業のグリッド
                      Expanded(
                        child: Row(
                          children: [
                            for (int day = 0; day < 5; day++) ...{
                              Expanded(
                                child: Column(
                                  children: [
                                    // 曜日ヘッダー
                                    Container(
                                      height: 35,
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                    // 授業コマ
                                    for (int period = 0;
                                        period < settingRow;
                                        period++) ...{
                                      Container(
                                        height: 82,
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.white,
                                        ),
                                      ),
                                    },
                                  ],
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
