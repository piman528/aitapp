import 'dart:io';

import 'package:aitapp/provider/file_downloading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenFilePdf extends HookConsumerWidget {
  const OpenFilePdf({
    super.key,
    required this.title,
    required this.file,
  });

  final String title;
  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSharefile = useState(false);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: isSharefile.value
                ? null
                : () async {
                    ref.read(fileDownloadingProvider.notifier).state = true;
                    isSharefile.value = true;
                    final xfile = [XFile(file.path)];
                    await Share.shareXFiles(xfile);
                    await Future<void>.delayed(
                      const Duration(milliseconds: 500),
                    );
                    isSharefile.value = false;
                    ref.read(fileDownloadingProvider.notifier).state = false;
                  },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        file,
      ),
    );
  }
}
