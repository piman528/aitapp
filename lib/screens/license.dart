import 'package:flutter/material.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LicensePage(
      applicationName: '愛工大アプリ',
      // applicationVersion: '1.0.0', // バージョン
    );
  }
}
