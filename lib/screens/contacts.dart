import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('各所連絡先'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('電話番号です'),
            subtitle: const Text('01234567890'),
            onTap: () => launchUrl(
              Uri(
                scheme: 'tel',
                path: '01234567890',
              ),
            ),
            trailing: const Icon(Icons.phone),
          ),
        ],
      ),
    );
  }
}
