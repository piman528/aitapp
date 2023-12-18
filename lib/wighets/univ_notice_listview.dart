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
  Future<void> _load() async {
    final list = ref.read(idPasswordProvider);
    await widget.getNotice.create(list[0], list[1]);
    final result = await widget.getNotice.getUnivNoticelist();
    final filteredResult = _filteredList(result);
    setState(() {
      final futureList = ListView.builder(
        itemCount: result.length,
        itemBuilder: (c, i) {
          return UnivNoticeItem(
            notice: result[i],
            index: result.indexOf(filteredResult[i]),
            getNotice: widget.getNotice,
            tap: true,
          );
        },
      );
    });
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

  @override
  Widget build(BuildContext context) {
    final oldList = ref.watch(univNoticesProvider);
    Widget futureList = FutureBuilder(
      future: _load(),
      builder:
          (BuildContext context, AsyncSnapshot<List<UnivNotice>> snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .watch(univNoticesProvider.notifier)
                .reloadNotices(snapshot.data!);
          });
          final result = _filteredList(snapshot.data!);
          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (c, i) {
              return UnivNoticeItem(
                notice: result[i],
                index: snapshot.data!.indexOf(result[i]),
                getNotice: widget.getNotice,
                tap: true,
              );
            },
          );
        } else if (oldList != null) {
          final result = _filteredList(oldList);
          return Expanded(
            child: Column(
              children: [
                const LinearProgressIndicator(),
                Expanded(
                  child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (c, i) {
                      return UnivNoticeItem(
                        notice: result[i],
                        index: oldList.indexOf(result[i]),
                        getNotice: widget.getNotice,
                        tap: false,
                      );
                    },
                  ),
                ),
              ],
            ),
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
      },
    );
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          final list = await _load();
          setState(() {
            final result = _filteredList(list);
            futureList = ListView.builder(
              itemCount: result.length,
              itemBuilder: (c, i) {
                return UnivNoticeItem(
                  notice: result[i],
                  index: list.indexOf(result[i]),
                  getNotice: widget.getNotice,
                  tap: true,
                );
              },
            );
          });
        },
        child: futureList,
      ),
    );
  }
}
