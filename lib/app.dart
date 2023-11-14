import 'package:aitapp/router.dart';
import 'package:aitapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: CustomNavigationHelper.router,
      theme: buildThemeLight(),
      // darkTheme: buildThemeDark(),
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: SizedBox(
        height: 84,
        child: BottomNavigationBar(
          iconSize: 20,
          selectedFontSize: 12,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.child.currentIndex,
          onTap: (index) {
            widget.child.goBranch(
              index,
              initialLocation: index == widget.child.currentIndex,
            );
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'お知らせ'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: '時間割'),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: '時刻表',
            ),
          ],
        ),
      ),
    );
  }
}
