import 'package:flutter/material.dart';

class NoticeDetail extends StatelessWidget {
  const NoticeDetail({super.key});

  @override
  Widget build(BuildContext context) {
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
