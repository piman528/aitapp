import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
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
  bool isLoading = true;
  bool isManual = false;

  @override
  void initState() {
    _load();
    super.initState();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
    });
    final identity = ref.read(idPasswordProvider);
    await widget.getNotice.create(identity[0], identity[1]);
    final result = await widget.getNotice.getUnivNoticelist();
    if (mounted) {
      setState(() {
        ref.read(univNoticesProvider.notifier).reloadNotices(result);
        isLoading = false;
      });
    }
  }

  List<UnivNotice> _filteredList(List<UnivNotice> list) {
    final result = list
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
    return result;
  }

  Widget _content() {
    if (ref.read(univNoticesProvider) != null) {
      final result = ref.read(univNoticesProvider)!;
      final filteredResult = _filteredList(result);
      return ListView.builder(
        itemCount: filteredResult.length,
        itemBuilder: (c, i) {
          return UnivNoticeItem(
            notice: filteredResult[i],
            index: result.indexOf(filteredResult[i]),
            getNotice: widget.getNotice,
            tap: !isLoading,
          );
        },
      );
    } else {
      return const Center(
        child: SizedBox(
          height: 25, //指定
          width: 25, //指定
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (isLoading &&
              ref.read(univNoticesProvider) != null &&
              !isManual) ...{
            const LinearProgressIndicator(),
          },
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  isManual = true;
                });
                await _load();
              },
              child: _content(),
            ),
          ),
        ],
      ),
    );
  }
}
