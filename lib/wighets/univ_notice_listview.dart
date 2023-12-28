import 'dart:io';

import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UnivNoticeList extends ConsumerStatefulWidget {
  const UnivNoticeList({
    super.key,
    required this.getNotice,
    required this.loading,
  });

  final GetNotice getNotice;
  final void Function({required bool state}) loading;

  @override
  ConsumerState<UnivNoticeList> createState() => _UnivNoticeListState();
}

class _UnivNoticeListState extends ConsumerState<UnivNoticeList> {
  final univController = TextEditingController();
  String univFilter = '';
  String? error;
  bool isLoading = true;
  bool isManual = false;
  int page = 10;
  int beforeReloadLengh = 0;
  Widget content = const Center(
    child: SizedBox(
      height: 25, //指定
      width: 25, //指定
      child: CircularProgressIndicator(),
    ),
  );

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
    _load(true, false);
    super.initState();
  }

  Future<void> _load(bool withLogin, bool isContinuation) async {
    late final List<UnivNotice> result;
    widget.loading(state: true);
    setState(() {
      isLoading = true;
    });
    try {
      if (withLogin) {
        final identity = ref.read(idPasswordProvider);
        await widget.getNotice.create(identity[0], identity[1]);
      }
      if (!isContinuation) {
        result = await widget.getNotice.getUnivNoticelist(page);
      } else {
        result = await widget.getNotice.getUnivNoticelistNext(page);
      }
      if (mounted) {
        ref.watch(univNoticesProvider.notifier).reloadNotices(result);
      }
    } on SocketException {
      if (mounted) {
        setState(() {
          error = 'インターネットに接続できません';
        });
      }
    } on Exception catch (err) {
      if (mounted) {
        setState(() {
          error = err.toString();
        });
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    widget.loading(state: false);
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

  @override
  Widget build(BuildContext context) {
    if (ref.read(univNoticesProvider) != null) {
      if (error == null) {
        final result = ref.read(univNoticesProvider)!;
        final filteredResult = _filteredList(result);
        content = ListView.builder(
          itemCount: filteredResult.length,
          itemBuilder: (c, i) {
            if (i == filteredResult.length - 3) {
              if (!isLoading && filteredResult.length != beforeReloadLengh) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  page += 10;
                  beforeReloadLengh = filteredResult.length;
                  _load(false, true);
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
        Fluttertoast.showToast(msg: error.toString());
      }
    } else if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }
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
              await _load(true, false);
            },
            child: content,
          ),
        ),
      ],
    );
  }
}
