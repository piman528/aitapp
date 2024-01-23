import 'package:aitapp/screens/webview.dart';
import 'package:flutter/material.dart';

class CourseRegistration extends StatelessWidget {
  const CourseRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('履修処理')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('履修登録'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => const WebViewScreen(
                    title: '履修登録',
                    url:
                        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('履修取消'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => const WebViewScreen(
                    title: '履修取消',
                    url:
                        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/kmgCou04/',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('抽選履修登録'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => const WebViewScreen(
                    title: '抽選履修登録',
                    url:
                        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/lotteryFirstArrival/',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('抽選履修登録結果'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => const WebViewScreen(
                    title: '抽選履修登録結果',
                    url:
                        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/lotteryRegistResult/',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
