import 'package:aitapp/core/get_notice.dart';
import 'package:aitapp/wighet/notices.dart';
import 'package:flutter/material.dart';

class ClassNoticeList extends StatelessWidget {
  const ClassNoticeList({super.key});
  Future<List<ClassNotice>> fetchData() async {
    // モデルから非同期処理でリストを取得する
    return getClassNoticelist();
  }

  @override
  Widget build(BuildContext context) {
    final futureBuilder = FutureBuilder<List<ClassNotice>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // データの取得中の場合に表示するWidget
          return const Center(
            child: SizedBox(
              height: 25, //指定
              width: 25, //指定
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // エラーが発生した場合に表示するWidget
          return Text('エラー: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // データが空の場合に表示するWidget
          return const Text('データがありません');
        } else {
          // データの取得が完了した場合に表示するWidget
          final list = ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (c, i) => snapshot.data![i].modelToWidget(context),
          );
          return Expanded(child: list);
        }
      },
    );
    return futureBuilder;
  }
}

class UnivNoticeList extends StatelessWidget {
  const UnivNoticeList({super.key});
  Future<List<UnivNotice>> fetchData() async {
    // モデルから非同期処理でリストを取得する
    return getUnivNoticelist();
  }

  @override
  Widget build(BuildContext context) {
    final futureBuilder = FutureBuilder<List<UnivNotice>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // データの取得中の場合に表示するWidget
          return const Center(
            child: SizedBox(
              height: 25, //指定
              width: 25, //指定
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // エラーが発生した場合に表示するWidget
          return Text('エラー: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // データが空の場合に表示するWidget
          return const Text('データがありません');
        } else {
          // データの取得が完了した場合に表示するWidget
          final list = ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (c, i) => snapshot.data![i].modelToWidget(context),
          );
          return Expanded(child: list);
        }
      },
    );
    return futureBuilder;
  }
}
