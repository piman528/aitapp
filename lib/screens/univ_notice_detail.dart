import 'package:flutter/material.dart';

class UnivNoticeDetailScreen extends StatelessWidget {
  const UnivNoticeDetailScreen({super.key, required this.index});

  final int index;

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
