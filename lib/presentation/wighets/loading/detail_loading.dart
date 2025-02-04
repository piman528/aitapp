import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailLoadingWidget extends StatelessWidget {
  const DetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      highlightColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        children: [
          // タイトル
          Container(
            margin: const EdgeInsets.all(4),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          // メタデータ行1
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // メタデータ行2
          Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // 本文ブロック
          for (int i = 0; i < 5; i++) ...[
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
