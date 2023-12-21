import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/class_notices_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/wighets/class_notice.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassNoticeList extends ConsumerStatefulWidget {
  const ClassNoticeList({
    super.key,
    required this.getNotice,
  });

  final GetNotice getNotice;

  @override
  ConsumerState<ClassNoticeList> createState() => _ClassNoticeListState();
}

class _ClassNoticeListState extends ConsumerState<ClassNoticeList> {
  final classController = TextEditingController();
  String classFilter = '';
  bool isLoading = true;
  bool isManual = false;
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
    _load();
    super.initState();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
    });
    final identity = ref.read(idPasswordProvider);
    await widget.getNotice.create(identity[0], identity[1]);
    final result = await widget.getNotice.getClassNoticelist();
    if (mounted) {
      setState(() {
        ref.read(classNoticesProvider.notifier).reloadNotices(result);
        isLoading = false;
      });
    }
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

  Widget _content() {
    if (ref.read(classNoticesProvider) != null) {
      final result = ref.read(classNoticesProvider)!;
      final filteredResult = _filteredList(result);
      return ListView.builder(
        itemCount: filteredResult.length,
        itemBuilder: (c, i) {
          return ClassNoticeItem(
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
              await _load();
            },
            child: _content(),
          ),
        ),
      ],
    );
  }
}
