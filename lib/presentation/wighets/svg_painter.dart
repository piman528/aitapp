import 'package:aitapp/domain/types/map_shape.dart';
import 'package:aitapp/domain/types/map_shapes.dart';
import 'package:flutter/material.dart';

class SVGMapRender extends CustomPainter {
  SVGMapRender({
    required this.selectedShape,
    required this.shapes,
    required this.scale,
    required this.themeBrightness,
  });
  final double scale;
  final MapShapes shapes;
  final Paint _paint = Paint();
  Size _size = Size.zero;
  final MapShape? selectedShape;
  final Brightness themeBrightness;

  @override
  void paint(Canvas canvas, Size size) {
    // print(scale);
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, const Size(2793, 1431), size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      for (final shape in shapes.selectableShapes) {
        shape.transform(matrix);
      }
      for (final shape in shapes.unSelectableShapes) {
        shape.transform(matrix);
      }
    }

    canvas
      ..clipRect(Offset.zero & size)
      ..drawColor(
        themeBrightness == Brightness.dark
            ? const Color.fromARGB(255, 28, 28, 30)
            : const Color.fromARGB(255, 243, 243, 243),
        BlendMode.src,
      );

    // 選択不可能な建物を描画
    for (final shape in shapes.unSelectableShapes) {
      _drawShape(canvas, shape, false);

      // スケールが閾値を超えている場合、部屋を描画
      if (scale >= MapShape.roomVisibilityThreshold) {
        for (final room in shape.rooms) {
          _drawRoom(canvas, room);
        }
      }
    }

    // 選択可能な建物を描画
    for (final shape in shapes.selectableShapes) {
      _drawShape(canvas, shape, selectedShape == shape);

      // スケールが閾値を超えている場合、部屋を描画
      if (scale >= MapShape.roomVisibilityThreshold) {
        for (final room in shape.rooms) {
          _drawRoom(canvas, room);
        }
      }
    }
  }

  // 建物を描画するメソッド
  void _drawShape(Canvas canvas, MapShape shape, bool isSelected) {
    final path = shape.transformedPathList;
    if (path == null) return;
    final isScalable = shape.id != null;

    canvas.save(); // 変換状態を保存
    try {
      if (isSelected) {
        // 選択された建物の塗りつぶし
        _paint
          ..color = themeBrightness == Brightness.dark
              ? Colors.lightBlue.withValues(alpha: 0.2)
              : Colors.blue.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;
        for (final element in path) {
          canvas.drawPath(element, _paint);
        }

        // 選択された建物の輪郭
        _paint
          ..color = themeBrightness == Brightness.dark
              ? Colors.lightBlueAccent
              : Colors.blue
          ..strokeWidth = 1.0 / scale
          ..style = PaintingStyle.stroke;
        for (final element in path) {
          canvas.drawPath(element, _paint);
        }
      } else {
        // 非選択の建物の塗りつぶし
        if (shape.fillColor != null) {
          _paint
            ..color = themeBrightness == Brightness.dark
                ? shape.fillColor!.withValues(alpha: 0.5)
                : shape.fillColor!
            ..style = PaintingStyle.fill;
          for (final element in path) {
            canvas.drawPath(element, _paint);
          }
        }

        // 非選択の建物の輪郭
        _paint
          ..color = themeBrightness == Brightness.dark
              ? shape.strokeColor.withValues(alpha: 1)
              : shape.strokeColor.withValues(alpha: 1)
          ..strokeWidth = isScalable
              ? shape.strokeWidth / (scale * 3)
              : shape.strokeWidth / 10
          ..style = PaintingStyle.stroke;
        for (final element in path) {
          canvas.drawPath(element, _paint);
        }
      }
    } finally {
      canvas.restore(); // 必ず変換状態を復元
    }
  }

  // 部屋を描画するメソッド
  void _drawRoom(Canvas canvas, MapShape room) {
    final path = room.transformedPathList;
    if (path == null) return;

    canvas.save(); // 変換状態を保存
    try {
      // 部屋の塗りつぶし
      if (room.fillColor != null) {
        _paint
          ..color = themeBrightness == Brightness.dark
              ? room.fillColor!.withValues(alpha: 0.3)
              : room.fillColor!.withValues(alpha: 0.5)
          ..style = PaintingStyle.fill;
        for (final element in path) {
          canvas.drawPath(element, _paint);
        }
      }

      // 部屋の輪郭
      _paint
        ..color = themeBrightness == Brightness.dark
            ? room.strokeColor.withValues(alpha: 0.8)
            : room.strokeColor
        ..strokeWidth = room.strokeWidth / (scale * 2)
        ..style = PaintingStyle.stroke;
      for (final element in path) {
        canvas.drawPath(element, _paint);
      }
    } finally {
      canvas.restore(); // 必ず変換状態を復元
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
