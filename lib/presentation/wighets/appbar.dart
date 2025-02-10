import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.only(top: 8, right: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: Scaffold.of(context).openDrawer,
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 28,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
