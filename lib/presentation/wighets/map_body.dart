import 'package:aitapp/application/state/map_shapes/mapshapes_provider.dart';
import 'package:aitapp/presentation/wighets/svg_painter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SVGMap extends ConsumerWidget {
  const SVGMap({
    super.key,
    required this.scale,
  });
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapShapesNotifierProvider);
    Offset? pointerDownPosition;

    if (mapState.shapes.isNotEmpty) {
      return GestureDetector(
        onTapDown: (details) {
          pointerDownPosition = details.localPosition;
        },
        onTapUp: (details) {
          if (details.localPosition == pointerDownPosition) {
            final select = mapState.shapes.firstWhereOrNull((shape) {
              final path = shape.transformedPath;
              return path!.contains(details.localPosition) &&
                  shape.isSelectable;
            });
            if (select != null) {
              ref
                  .read(mapShapesNotifierProvider.notifier)
                  .selectShape(select.id);
            }
          }
          pointerDownPosition = null;
        },
        child: RepaintBoundary(
          child: CustomPaint(
            painter: SVGMapRender(
              selectedShapes: mapState.getSelectedShapes(),
              shapes: mapState.shapes,
              scale: scale,
              themeBrightness: Theme.of(context).brightness,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
