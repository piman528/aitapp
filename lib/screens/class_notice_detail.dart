import 'dart:io';

import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class ClassNoticeDetailScreen extends StatefulWidget {
  const ClassNoticeDetailScreen({
    super.key,
    required this.index,
    required this.getNotice,
  });

  final int index;
  final GetNotice getNotice;

  @override
  State<ClassNoticeDetailScreen> createState() =>
      _ClassNoticeDetailScreenState();
}

class _ClassNoticeDetailScreenState extends State<ClassNoticeDetailScreen> {
  bool isDownloading = false;
  String? error;
  ClassNotice? classNotice;
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
      classNotice = await widget.getNotice.getClassNoticeDetail(widget.index);
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

  @override
  Widget build(BuildContext context) {
    if (classNotice != null) {
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
                  Text(classNotice!.sendAt),
                  Text(classNotice!.sender),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SelectionArea(
                child: Column(
                  children: [
                    Text(
                      classNotice!.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    for (final text in classNotice!.content) ...{
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
                    if (classNotice!.url.isNotEmpty) ...{
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
                      for (final url in classNotice!.url) ...{
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
