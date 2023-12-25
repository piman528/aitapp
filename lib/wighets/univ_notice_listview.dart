import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnivNoticeList extends ConsumerStatefulWidget {
  const UnivNoticeList({
    super.key,
    required this.getNotice,
  });

  final GetNotice getNotice;

  @override
  ConsumerState<UnivNoticeList> createState() => _UnivNoticeListState();
}

class _UnivNoticeListState extends ConsumerState<UnivNoticeList> {
  final univController = TextEditingController();
  String univFilter = '';
  bool isLoading = true;
  bool isManual = false;
  int page = 10;
  int beforeReloadLengh = 0;
  void _printUnivFilterValue1() {
    setState(() {
      univFilter = univController.text;
    });
  }

  @override
  void dispose() {
    univController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    univController.addListener(_printUnivFilterValue1);
    _load(true);
    super.initState();
  }

  Future<void> _load(bool withLogin) async {
    setState(() {
      isLoading = true;
    });
    if (withLogin) {
      final identity = ref.read(idPasswordProvider);
      await widget.getNotice.create(identity[0], identity[1]);
    }
    final result = await widget.getNotice.getUnivNoticelist(page);
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
                    univFilter.toLowerCase(),
                  ) ||
              univNotice.sender.toLowerCase().contains(
                    univFilter.toLowerCase(),
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
          if (i == filteredResult.length - 3) {
            if (!isLoading && filteredResult.length != beforeReloadLengh) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                page += 10;
                beforeReloadLengh = filteredResult.length;
                _load(false);
              });
            }
          }
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
    return Column(
      children: [
        isLoading && ref.read(univNoticesProvider) != null && !isManual
            ? const LinearProgressIndicator(minHeight: 2)
            : const SizedBox(
                height: 2,
              ),
        SearchBarWidget(
          controller: univController,
          hintText: '送信元、キーワードで検索',
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                isManual = true;
              });
              page = 5;
              await _load(true);
            },
            child: _content(),
          ),
        ),
      ],
    );
  }
}
