import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/class_notices_provider.dart';
import 'package:aitapp/wighets/class_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassNoticeList extends ConsumerWidget {
  const ClassNoticeList(
      {super.key, required this.filterText, required this.getNotice});

  final GetNotice getNotice;
  final String filterText;

  Future<void> _create() async {
    await getNotice.create();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(classNoticesProvider);
    if (asyncValue.isLoading) {
      ref
          .read(classNoticesProvider.notifier)
          .fetchNotices(getNotice, _create());
    }
    return asyncValue.when(
      data: (data) {
        final result = data
            .where(
              (classNotice) =>
                  classNotice.subject.toLowerCase().contains(filterText) ||
                  classNotice.title.toLowerCase().contains(filterText) ||
                  classNotice.sender.toLowerCase().contains(filterText),
            )
            .toList();
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(classNoticesProvider.notifier)
                  .reloadNotices(getNotice, _create());
            },
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (c, i) => ClassNoticeItem(
                notice: result[i],
                index: data.indexOf(result[i]),
                getNotice: getNotice,
              ),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: SizedBox(
          height: 25, //指定
          width: 25, //指定
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Text('An error occurred'),
    );
  }
}
