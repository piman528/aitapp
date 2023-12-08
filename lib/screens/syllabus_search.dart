import 'package:aitapp/wighets/search_bar.dart';
import 'package:flutter/material.dart';

class SyllabusSearchScreen extends StatelessWidget {
  const SyllabusSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'シラバス検索',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: SearchBarWidget(
        controller: TextEditingController(),
        hintText: '教授名、授業名で検索',
      ),
    );
  }
}
