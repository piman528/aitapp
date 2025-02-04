import 'dart:ui';

import 'package:flutter/material.dart';

class BuildSection extends StatelessWidget {
  const BuildSection({super.key, required this.title, required this.content});

  final String title;
  final List<String> content;

  IconData _getSectionIcon(String sectionTitle) {
    switch (sectionTitle) {
      case '概要':
        return Icons.description;
      case '計画':
        return Icons.event_note;
      case '学習到達目標':
        return Icons.emoji_events;
      case '方法と特徴':
        return Icons.lightbulb;
      case '成績評価':
        return Icons.assessment;
      case '教員メッセージ':
        return Icons.message;
      case '教科書':
        return Icons.menu_book;
      case '参考書':
        return Icons.book;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(
                  _getSectionIcon(title),
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final text in content)
                  if (text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SelectableText(
                        text,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        selectionHeightStyle: BoxHeightStyle.max,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
