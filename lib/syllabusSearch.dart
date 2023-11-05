import 'package:flutter/material.dart';

class syllabusSearch extends StatelessWidget {
  const syllabusSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final textField = Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          fillColor: const Color.fromARGB(255, 233, 233, 233),
          filled: true,
          // border: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          // labelText: 'あなたの名前',
          hintText: '教授名、授業名で検索',
        ),
      ),
    );
    final con = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('シラバス検索', style: TextStyle(color: Colors.black)),
      ),
      body: textField,
    );
    return con;
  }
}
