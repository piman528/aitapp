import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnivNoticeList extends ConsumerWidget {
  UnivNoticeList({super.key});

  final getNotice = GetNotice();

  Future<void> _create() async {
    await getNotice.create();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(univNoticesProvider);
    if (asyncValue.isLoading) {
      ref.read(univNoticesProvider.notifier).fetchNotices(getNotice, _create());
    }
    return asyncValue.when(
      data: (data) => Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(univNoticesProvider.notifier)
                .reloadNotices(getNotice, _create());
          },
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (c, i) => UnivNoticeItem(
              notice: data[i],
              index: i,
              getNotice: getNotice,
            ),
          ),
        ),
      ),
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