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

  Future<void> _load() async {
    final list = ref.read(idPasswordProvider);
    await widget.getNotice.create(list[0], list[1]);
    final result = await widget.getNotice.getUnivNoticelist();
    ref.read(univNoticesProvider.notifier).reloadNotices(result);
    isLoading = false;
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
    if (isLoading) {
      if (ref.read(univNoticesProvider) != null) {
        final result = ref.read(univNoticesProvider)!;
        return ListView.builder(
          itemCount: _filteredList(result).length,
          itemBuilder: (c, i) {
            return UnivNoticeItem(
              notice: _filteredList(result)[i],
              index: result.indexOf(_filteredList(result)[i]),
              getNotice: widget.getNotice,
              tap: false,
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
    } else {
      final result = ref.read(univNoticesProvider)!;
      return ListView.builder(
        itemCount: _filteredList(result).length,
        itemBuilder: (c, i) {
          return UnivNoticeItem(
            notice: _filteredList(result)[i],
            index: result.indexOf(_filteredList(result)[i]),
            getNotice: widget.getNotice,
            tap: false,
          );
        },
      );
    }
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await _load();
        },
        child: _content(),
      ),
    );
  }
}
