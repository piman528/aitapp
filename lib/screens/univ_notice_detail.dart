import 'dart:io';

import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/link.dart';

class UnivNoticeDetailScreen extends StatefulWidget {
  const UnivNoticeDetailScreen({
    super.key,
    required this.index,
    required this.getNotice,
  });

  final int index;
  final GetNotice getNotice;

  @override
  State<UnivNoticeDetailScreen> createState() => _UnivNoticeDetailScreenState();
}

class _UnivNoticeDetailScreenState extends State<UnivNoticeDetailScreen> {
  bool isDownloading = false;
  String? error;
  UnivNotice? univNotice;
  final _regExp = RegExp(
    r"(http(s)?:\/\/[a-zA-Z0-9-.!'()*;/?:@&=+$,%_#]+)",
    caseSensitive: false,
  );
  Widget content = const Center(
    child: SizedBox(
      height: 25, //指定
      width: 25, //指定
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      univNotice = await widget.getNotice.getUnivNoticeDetail(widget.index);
    } on SocketException {
      setState(() {
        error = 'インターネットに接続できません';
      });
    } on Exception catch (err) {
      setState(() {
        error = err.toString();
      });
    }
    setState(() {});
  }

  Future<void> _fileShare(MapEntry<String, String> entries) async {
    setState(() {
      isDownloading = true;
    });
    try {
      await widget.getNotice.shareFile(entries);
    } on SocketException {
      await Fluttertoast.showToast(msg: 'インターネットに接続できません');
    } on Exception catch (err) {
      await Fluttertoast.showToast(msg: err.toString());
    }

    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (univNotice != null) {
      content = SingleChildScrollView(
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
                  Text(univNotice!.sendAt),
                  Text(univNotice!.sender),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SelectionArea(
                child: Column(
                  children: [
                    Text(
                      univNotice!.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    for (final text in univNotice!.content) ...{
                      if (text != '') ...{
                        if (_regExp.stringMatch(text) != null) ...{
                          Link(
                            uri: Uri.parse(_regExp.stringMatch(text)!),
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
                    if (univNotice!.url.isNotEmpty) ...{
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
                      for (final url in univNotice!.url) ...{
                        Link(
                          uri: Uri.parse(_regExp.stringMatch(url)!),
                          target: LinkTarget.blank,
                          builder: (context, followLink) => TextButton(
                            onPressed: followLink,
                            child: Text(url),
                          ),
                        ),
                      },
                    },
                    if (univNotice!.files!.isNotEmpty) ...{
                      const Text(
                        '添付ファイル',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (final entries in univNotice!.files!.entries) ...{
                        TextButton(
                          onPressed: isDownloading
                              ? null
                              : () {
                                  _fileShare(entries);
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
    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '詳細',
        ),
      ),
      body: content,
    );
  }
}
