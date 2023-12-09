import 'package:aitapp/models/get_notice.dart';
import 'package:flutter/material.dart';

class ClassNoticeDetailScreen extends StatelessWidget {
  const ClassNoticeDetailScreen({
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
      body: const Text('こんにちは'),
    );
  }
}
