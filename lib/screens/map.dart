import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学内マップ'),
      ),
      body: SfPdfViewer.asset(
        'assets/pdfs/guide-campus-yakusa.pdf',
      ),
    );
  }
}
