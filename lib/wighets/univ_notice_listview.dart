import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnivNoticeList extends ConsumerStatefulWidget {
  const UnivNoticeList({
    super.key,
    required this.filterText,
    required this.getNotice,
  });

  final GetNotice getNotice;
  final String filterText;

  @override
  ConsumerState<UnivNoticeList> createState() => _UnivNoticeListState();
}

class _UnivNoticeListState extends ConsumerState<UnivNoticeList> {
  @override
  void initState() {
    super.initState();
    ref
        .read(univNoticesProvider.notifier)
        .reloadNotices(widget.getNotice, _create());
  }

  Future<void> _create() async {
    final list = ref.read(idPasswordProvider);
    await widget.getNotice.create(list[0], list[1]);
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(univNoticesProvider);
    return asyncValue.when(
      data: (data) {
        final result = data
            .where(
              (univNotice) =>
                  univNotice.title.toLowerCase().contains(
                        widget.filterText.toLowerCase(),
                      ) ||
                  univNotice.sender.toLowerCase().contains(
                        widget.filterText.toLowerCase(),
                      ),
            )
            .toList();
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(univNoticesProvider.notifier)
                  .reloadNotices(widget.getNotice, _create());
            },
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (c, i) {
                return UnivNoticeItem(
                  notice: result[i],
                  index: data.indexOf(result[i]),
                  getNotice: widget.getNotice,
                );
              },
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
