import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenAssetPdf extends StatelessWidget {
  const OpenAssetPdf({
    super.key,
    required this.title,
    required this.path,
  });

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(title),
      ),
      body: SfPdfViewer.asset(
        path,
      ),
    );
  }
}
