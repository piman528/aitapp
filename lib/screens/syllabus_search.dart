import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/syllabus_search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyllabusSearchScreen extends HookWidget {
  const SyllabusSearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final syllabusList = useState<Widget>(const SizedBox());

    void onSubmit(String word) {
      syllabusList.value = SyllabusSearchList(
        searchText: word,
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
          syllabusList.value,
        ],
      ),
    );
  }
}
