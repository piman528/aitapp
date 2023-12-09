import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnivNoticeList extends ConsumerWidget {
  const UnivNoticeList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(univNoticesProvider);
    if (asyncValue.isLoading) {
      ref.read(univNoticesProvider.notifier).fetchData();
    }
    return asyncValue.when(
      data: (data) => Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(univNoticesProvider.notifier).reloadData();
          },
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (c, i) => UnivNoticeItem(
              notice: data[i],
              index: i,
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
