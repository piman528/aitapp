import 'package:aitapp/const.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget(
      {super.key, required this.hintText, required this.controller});
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Measure.p_a16,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
          prefixIcon: const Icon(Icons.search),
          // fillColor: Color.fromARGB(255, 233, 233, 233),
          filled: true,
          // border: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
