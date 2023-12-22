import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class StudentHandbookScreen extends StatelessWidget {
  const StudentHandbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学生便覧'),
      ),
      body: const PDFView(
        filePath: 'assets/pdfs/binran2023.pdf',
        // pageFling: true,
      ),
    );
  }
}
