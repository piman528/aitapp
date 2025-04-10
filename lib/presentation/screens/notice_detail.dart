import 'package:aitapp/application/state/class_notice_detail/notice_detail.dart';
import 'package:aitapp/presentation/wighets/loading/detail_loading.dart';
import 'package:aitapp/presentation/wighets/notice_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeDetailScreen extends HookConsumerWidget {
  const NoticeDetailScreen({
    super.key,
    required this.index,
    required this.isCommon,
    required this.title,
    required this.page,
  });

  final int index;
  final bool isCommon;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(noticeDetailNotifierProvider);

    useEffect(
      () {
        if (asyncValue.isLoading || asyncValue.hasError) {
          ref.read(noticeDetailNotifierProvider.notifier).fetchData(
                index: index,
                page: page,
                isCommon: isCommon,
                title: title,
              );
        }
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '詳細',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: asyncValue.when(
        data: (notice) => NoticeDetailWidget(notice: notice),
        error: (error, stack) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const DetailLoadingWidget(),
      ),
    );
  }
}
