import 'dart:io';

import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/class_notices_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/wighets/class_notice.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClassNoticeList extends ConsumerStatefulWidget {
  const ClassNoticeList({
    super.key,
    required this.getNotice,
    required this.loading,
  });

  final GetNotice getNotice;
  final void Function({required bool state}) loading;

  @override
  ConsumerState<ClassNoticeList> createState() => _ClassNoticeListState();
}

class _ClassNoticeListState extends ConsumerState<ClassNoticeList> {
  final classController = TextEditingController();
  String classFilter = '';
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

  void _setClassFilterValue2() {
    setState(() {
      classFilter = classController.text;
    });
  }

  @override
  void dispose() {
    classController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    classController.addListener(_setClassFilterValue2);
    _load(true, false);
    super.initState();
  }

  Future<void> _load(bool withLogin, bool isContinuation) async {
    late final List<ClassNotice> result;
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
        result = await widget.getNotice.getClassNoticelist(page);
      } else {
        result = await widget.getNotice.getClassNoticelistNext(page);
      }
      if (mounted) {
        ref.watch(classNoticesProvider.notifier).reloadNotices(result);
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

  List<ClassNotice> _filteredList(List<ClassNotice> list) {
    final result = list
        .where(
          (classNotice) =>
              classNotice.subject.toLowerCase().contains(
                    classFilter.toLowerCase(),
                  ) ||
              classNotice.title.toLowerCase().contains(
                    classFilter.toLowerCase(),
                  ) ||
              classNotice.sender.toLowerCase().contains(
                    classFilter.toLowerCase(),
                  ),
        )
        .toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (ref.read(classNoticesProvider) != null) {
      if (error == null) {
        final result = ref.read(classNoticesProvider)!;
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
            return ClassNoticeItem(
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
        isLoading && ref.read(classNoticesProvider) != null && !isManual
            ? const LinearProgressIndicator(minHeight: 2)
            : const SizedBox(
                height: 2,
              ),
        SearchBarWidget(
          controller: classController,
          hintText: '送信元、キーワードで検索',
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                isManual = true;
              });
              await _load(true, false);
            },
            child: content,
          ),
        ),
      ],
    );
  }
}
