import 'package:aitapp/const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Links extends StatelessWidget {
  const Links({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('各種リンク'),
      ),
      body: ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(links.entries.toList()[index].key),
            onTap: () => launchUrl(
              Uri.parse(
                links.entries.toList()[index].value,
              ),
            ),
            trailing: const Icon(Icons.link),
          );
        },
      ),
    );
  }
}
