import 'package:aitapp/domain/types/map_shape.dart';
import 'package:flutter/material.dart';

class SVGMapRender extends CustomPainter {
  SVGMapRender({
    required this.selectedShapes,
    required this.shapes,
    required this.scale,
    required this.themeBrightness,
  });
  final double scale;
  final List<MapShape> shapes;
  final Paint _paint = Paint();
  Size _size = Size.zero;
  final List<MapShape> selectedShapes;
  final Brightness themeBrightness;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, const Size(3200, 1600), size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      for (final shape in shapes) {
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

    // 建物を描画
    for (final shape in shapes) {
      _drawShape(canvas, shape, selectedShapes.contains(shape));

      // スケールが閾値を超えている場合、部屋を描画
      if (scale >= MapShape.ROOM_VISIBILITY_THRESHOLD) {
        for (final room in shape.rooms) {
          _drawRoom(canvas, room);
        }
      }
    }
  }

  // 建物を描画するメソッド
  void _drawShape(Canvas canvas, MapShape shape, bool isSelected) {
    final path = shape.transformedPath;
    if (isSelected) {
      // 選択された建物の塗りつぶし
      _paint
        ..color = themeBrightness == Brightness.dark
            ? Colors.lightBlue.withValues(alpha: 0.2)
            : Colors.blue.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path!, _paint);

      // 選択された建物の輪郭
      _paint
        ..color = themeBrightness == Brightness.dark
            ? Colors.lightBlueAccent
            : Colors.blue
        ..strokeWidth = shape.strokeWidth / scale * 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    } else {
      // 非選択の建物の塗りつぶし
      if (shape.fillColor != null) {
        _paint
          ..color = themeBrightness == Brightness.dark
              ? shape.fillColor!.withValues(alpha: 0.5)
              : shape.fillColor!
          ..style = PaintingStyle.fill;
        canvas.drawPath(path!, _paint);
      }

      // 非選択の建物の輪郭
      _paint
        ..color = themeBrightness == Brightness.dark
            ? shape.strokeColor.withValues(alpha: 1)
            : shape.strokeColor.withValues(alpha: 1)
        ..strokeWidth = shape.strokeWidth / (scale * 4)
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path!, _paint);
    }
  }

  // 部屋を描画するメソッド
  void _drawRoom(Canvas canvas, MapShape room) {
    final path = room.transformedPath;

    // 部屋の塗りつぶし
    if (room.fillColor != null) {
      _paint
        ..color = themeBrightness == Brightness.dark
            ? room.fillColor!.withValues(alpha: 0.3)
            : room.fillColor!.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path!, _paint);
    }

    // 部屋の輪郭
    _paint
      ..color = themeBrightness == Brightness.dark
          ? room.strokeColor.withValues(alpha: 0.8)
          : room.strokeColor
      ..strokeWidth = room.strokeWidth / (scale * 2)
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path!, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
