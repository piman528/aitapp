import 'package:flutter/material.dart';

class Attachment extends StatelessWidget {
  const Attachment({
    super.key,
    required this.attachName,
    required this.onTap,
    required this.isUrl,
  });

  final String attachName;
  final void Function()? onTap;
  final bool isUrl;

  IconData _getFileIcon() {
    if (isUrl) {
      return Icons.link_rounded;
    }

    final extension = attachName.toLowerCase();
    if (extension.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.png')) {
      return Icons.image;
    } else if (extension.endsWith('.doc') || extension.endsWith('.docx')) {
      return Icons.description;
    } else if (extension.endsWith('.xls') || extension.endsWith('.xlsx')) {
      return Icons.table_chart;
    } else if (extension.endsWith('.ppt') || extension.endsWith('.pptx')) {
      return Icons.slideshow;
    }
    return Icons.insert_drive_file;
  }

  String _getFileType(String fileName) {
    final extension = fileName.toLowerCase();
    if (extension.endsWith('.pdf')) {
      return 'PDFファイル';
    } else if (extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.png')) {
      return '画像ファイル';
    } else if (extension.endsWith('.doc') || extension.endsWith('.docx')) {
      return 'Wordファイル';
    } else if (extension.endsWith('.xls') || extension.endsWith('.xlsx')) {
      return 'Excelファイル';
    } else if (extension.endsWith('.ppt') || extension.endsWith('.pptx')) {
      return 'PowerPointファイル';
    }
    return 'ファイル';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFileIcon(),
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isUrl ? 'Webリンク' : _getFileType(attachName),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
