import 'package:aitapp/const.dart';
import 'package:aitapp/screens/webview.dart';
import 'package:flutter/material.dart';

class CourseRegistration extends StatelessWidget {
  const CourseRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('履修/アンケート/成績')),
      body: ListView(
        children: [
          for (final webAccessPage in webAccessPages) ...{
            ListTile(
              title: Text(webAccessPage.title),
              leading: Icon(webAccessPage.icon),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (ctx) => WebViewScreen(
                      title: webAccessPage.title,
                      url: webAccessPage.url,
                    ),
                  ),
                );
              },
            ),
          },
        ],
      ),
    );
  }
}
