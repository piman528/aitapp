import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SyllabusLoadingWidget extends StatelessWidget {
  const SyllabusLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withOpacity(0.5),
      highlightColor: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 20,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
