import 'dart:io';

import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/file_downloading_provider.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/link.dart';

class ClassNoticeDetailScreen extends HookConsumerWidget {
  const ClassNoticeDetailScreen({
    super.key,
    required this.index,
    required this.getNotice,
  });

  final int index;
  final GetNotice getNotice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regExp = useRef(
      RegExp(
        r"(http(s)?:\/\/[a-zA-Z0-9-.!'()*;/?:@&=+$,%_#]+)",
        caseSensitive: false,
      ),
    );
    final classNotice = useState<ClassNotice?>(null);
    final error = useState<String?>(null);
    final content = useState<Widget>(
      const Center(
        child: SizedBox(
          height: 25, //指定
          width: 25, //指定
          child: CircularProgressIndicator(),
        ),
      ),
    );
    final operation = useRef<CancelableOperation<void>?>(null);

    Future<void> loadData() async {
      try {
        classNotice.value = await getNotice.getClassNoticeDetail(index);
      } on SocketException {
        error.value = 'インターネットに接続できません';
      } on Exception catch (err) {
        error.value = err.toString();
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
        operation.value = CancelableOperation.fromFuture(loadData());
        return () {
          operation.value!.cancel();
        };
      },
      [],
    );

    if (classNotice.value != null) {
      content.value = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(classNotice.value!.sendAt),
                  Text(classNotice.value!.sender),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SelectionArea(
                child: Column(
                  children: [
                    Text(
                      classNotice.value!.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    for (final text in classNotice.value!.content) ...{
                      if (text != '') ...{
                        if (regExp.value.stringMatch(text) != null) ...{
                          Link(
                            uri: Uri.parse(regExp.value.stringMatch(text)!),
                            target: LinkTarget.blank,
                            builder: (context, followLink) => TextButton(
                              onPressed: followLink,
                              child: Text(text),
                            ),
                          ),
                        } else ...{
                          Text(text),
                        },
                        const SizedBox(
                          height: 20,
                        ),
                      },
                    },
                    if (classNotice.value!.url.isNotEmpty) ...{
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
                      for (final url in classNotice.value!.url) ...{
                        Link(
                          uri: Uri.parse(regExp.value.stringMatch(url)!),
                          target: LinkTarget.blank,
                          builder: (context, followLink) => TextButton(
                            onPressed: followLink,
                            child: Text(url),
                          ),
                        ),
                      },
                    },
                    if (classNotice.value!.files!.isNotEmpty) ...{
                      const Text(
                        '添付ファイル',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (final entries
                          in classNotice.value!.files!.entries) ...{
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
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
