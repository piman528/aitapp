import 'package:flutter/material.dart';

class CircularLoadingWidget extends StatelessWidget {
  const CircularLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
