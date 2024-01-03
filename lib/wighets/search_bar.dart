import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.onSubmitted,
  });
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: TextField(
        onSubmitted: onSubmitted,
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          prefixIcon: const Icon(Icons.search),
          fillColor: Theme.of(context).hoverColor,
          filled: true,
          // border: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          suffixIcon: controller.text != ''
              ? IconButton(
                  onPressed: controller.clear, //リセット処理
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
      ),
    );
  }
}
