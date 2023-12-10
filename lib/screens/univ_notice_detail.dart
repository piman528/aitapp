import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:flutter/material.dart';

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
    getNotice.getUnivNoticeDetail(index);
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
                      height: 40,
                    ),
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
                      Text(text),
                      const SizedBox(
                        height: 20,
                      ),
                    },
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