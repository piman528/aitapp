import 'dart:io';

import 'package:aitapp/application/state/class_timetable/class_timetable.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:aitapp/presentation/wighets/appbar.dart';
import 'package:aitapp/presentation/wighets/class_timetable_item.dart';
import 'package:aitapp/presentation/wighets/loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClassTimeTableScreen extends ConsumerWidget {
  const ClassTimeTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(classTimeTableNotifierProvider);
    final notifier = ref.read(classTimeTableNotifierProvider.notifier);

    return asyncValue.when(
      loading: () => const LoadingWidget(),
      error: (error, __) {
        if (error is SocketException) {
          return const Center(
            child: Text('インターネットに接続できません'),
          );
        } else {
          return Center(
            child: Text(error.toString()),
          );
        }
      },
      data: (data) => Column(
        children: [
          AppBarWidget(
            child: DefaultTabController(
              length: 2,
              initialIndex: data.selectSemester == Semester.early ? 0 : 1,
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: PopupMenuButton<int>(
                      initialValue: data.selectYear,
                      position: PopupMenuPosition.under,
                      surfaceTintColor: Theme.of(context).colorScheme.surface,
                      itemBuilder: (context) => data.timetable.keys
                          .map(
                            (year) => PopupMenuItem<int>(
                              value: year,
                              child: Text('$year年度'),
                            ),
                          )
                          .toList(),
                      onSelected: notifier.changeSelectYear,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${data.selectYear}年度',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        labelPadding: EdgeInsets.zero,
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        unselectedLabelColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.8),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w600),
                        unselectedLabelStyle:
                            const TextStyle(fontWeight: FontWeight.normal),
                        tabs: [
                          Tab(
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                Semester.early.displayName,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                Semester.late.displayName,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                        onTap: (index) {
                          notifier.changeSelectSemester(
                            [Semester.early, Semester.late][index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: TimeTable(
              classData: notifier.selectClassData,
            ),
          ),
        ],
      ),
    );
  }
}
