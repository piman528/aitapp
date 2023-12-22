import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudentHandbookScreen extends StatelessWidget {
  const StudentHandbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学生便覧'),
      ),
      body: SfPdfViewer.asset('assets/pdfs/binran_2023.pdf'),
    );
  }
}
