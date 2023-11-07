import 'package:aitapp/const.dart';
import 'package:flutter/material.dart';

class syllabusSearch extends StatelessWidget {
  const syllabusSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final textField = Container(
      padding: Measure.p_a16,
      child: const TextField(
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: Measure.br_8,
            borderSide: BorderSide.none,
          ),
          hintText: '教授名、授業名で検索',
        ),
      ),
    );

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
      body: textField,
    );
  }
}
