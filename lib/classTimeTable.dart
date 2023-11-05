import 'package:flutter/material.dart';

class classTimeTable extends StatelessWidget {
  const classTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('時間割', style: TextStyle(color: Colors.black)),
      ),
    );
    return con;
  }
}
