import 'dart:io';

import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/notice_detail.dart';
import 'package:aitapp/provider/file_downloading_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeDetailScreen extends HookConsumerWidget {
  const NoticeDetailScreen({
    super.key,
    required this.index,
    required this.getNotice,
    required this.isCommon,
    required this.title,
    required this.page,
  });

  final int index;
  final GetNotice getNotice;
  final bool isCommon;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = useState<String?>(null);
    final notice = useState<NoticeDetail?>(null);
    final operation = useRef<CancelableOperation<void>?>(null);
    final content = useState<Widget>(
      const Center(
        child: SizedBox(
          height: 25, //指定
          width: 25, //指定
          child: CircularProgressIndicator(),
        ),
      ),
    );

    Future<void> loadData() async {
      try {
        notice.value = await getNotice.getNoticeDetail(
          pageNumber: index,
          isCommon: isCommon,
        );
      } on SocketException {
        error.value = 'インターネットに接続できません';
      } on Exception {
        try {
          final identity = ref.read(idPasswordProvider);
          await getNotice.create(identity[0], identity[1]);
          final noticelist = await getNotice.getNoticelist(
            page: page,
            isCommon: isCommon,
            withLogin: true,
          );
          final reSearchIndex = noticelist.indexWhere(
            (element) => element.title == title,
          );
          notice.value = await getNotice.getNoticeDetail(
            pageNumber: reSearchIndex,
            isCommon: isCommon,
          );
        } on Exception catch (err) {
          error.value = err.toString();
        }
      }
    }

    Future<void> fileShare(MapEntry<String, String> entries) async {
      ref.read(fileDownloadingProvider.notifier).state = true;
      try {
        await getNotice.shareFile(entries, context);
      } on SocketException {
        await Fluttertoast.showToast(msg: 'インターネットに接続できません');
      } on Exception catch (err) {
        await Fluttertoast.showToast(msg: err.toString());
      }

      await Future<void>.delayed(const Duration(milliseconds: 500));
      ref.read(fileDownloadingProvider.notifier).state = false;
    }

    useEffect(
      () {
        operation.value = CancelableOperation.fromFuture(
          loadData(),
        );

        return () {
          operation.value!.cancel();
        };
      },
      [],
    );
    if (notice.value != null) {
      content.value = ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(notice.value!.sendAt),
              Text(notice.value!.sender),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SelectionArea(
            child: Column(
              children: [
                Text(
                  notice.value!.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                HtmlWidget(
                  notice.value!.content,
                  customStylesBuilder: (element) => element.localName == 'a'
                      ? {
                          'color':
                              Theme.of(context).colorScheme.primary.toString(),
                          'text-decoration': 'none',
                          'font-weight': '500',
                        }
                      : null,
                ),
                if (notice.value!.url.isNotEmpty) ...{
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '参考URL',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (final url in notice.value!.url) ...{
                    TextButton(
                      child: Text(url),
                      onPressed: () {
                        launchUrl(Uri.parse(url));
                      },
                    ),
                  },
                },
                if (notice.value!.files.isNotEmpty) ...{
                  const Text(
                    '添付ファイル',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (final entries in notice.value!.files.entries) ...{
                    TextButton(
                      onPressed: ref.watch(fileDownloadingProvider)
                          ? null
                          : () {
                              fileShare(entries);
                            },
                      child: Text(entries.key),
                    ),
                  },
                },
              ],
            ),
          ),
        ],
      );
    }
    if (error.value != null) {
      content.value = Center(
        child: Text(error.value!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '詳細',
        ),
      ),
      body: content.value,
    );
  }
}
