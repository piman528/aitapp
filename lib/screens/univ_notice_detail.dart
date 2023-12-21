import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class UnivNoticeDetailScreen extends StatelessWidget {
  const UnivNoticeDetailScreen({
    super.key,
    required this.index,
    required this.getNotice,
  });

  final int index;
  final GetNotice getNotice;

  @override
  Widget build(BuildContext context) {
    final regExp = RegExp(
      r"(http(s)?:\/\/[a-zA-Z0-9-.!'()*;/?:@&=+$,%_#]+)",
      caseSensitive: false,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '詳細',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: getNotice.getUnivNoticeDetail(index),
        builder: (BuildContext context, AsyncSnapshot<UnivNotice> snapshot) {
          if (snapshot.hasData) {
            final getnotice = snapshot.data;
            return SingleChildScrollView(
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
                        Text(getnotice!.sendAt),
                        Text(getnotice.sender),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SelectionArea(
                      child: Column(
                        children: [
                          Text(
                            getnotice.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          for (final text in getnotice.content) ...{
                            if (text != '') ...{
                              if (regExp.stringMatch(text) != null) ...{
                                Link(
                                  uri: Uri.parse(regExp.stringMatch(text)!),
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
                          if (getnotice.url.isNotEmpty) ...{
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
                            for (final url in getnotice.url) ...{
                              Link(
                                uri: Uri.parse(regExp.stringMatch(url)!),
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
          } else if (snapshot.hasError) {
            return const Text('データが存在しません');
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
      ),
    );
  }
}
