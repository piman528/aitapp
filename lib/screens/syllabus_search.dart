import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/syllabus_search_list.dart';
import 'package:flutter/material.dart';

class SyllabusSearchScreen extends StatefulWidget {
  const SyllabusSearchScreen({
    super.key,
  });

  @override
  State<SyllabusSearchScreen> createState() => _SyllabusSearchScreenState();
}

class _SyllabusSearchScreenState extends State<SyllabusSearchScreen> {
  final controller = TextEditingController();
  Widget syllabusList = const SizedBox();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSubmit(String word) {
    setState(() {
      syllabusList = SyllabusSearchList(
        searchText: word,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'シラバス検索',
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSubmitted: onSubmit,
            controller: controller,
            hintText: '教授名、授業名で検索',
          ),
          syllabusList,
        ],
      ),
    );
  }
}
