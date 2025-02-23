import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class MapShape {
  MapShape({
    required String strPath,
    required this.strokeColor,
    required this.strokeWidth,
    required this.isSelectable,
    required this.id,
    this.fillColor,
    this.rooms = const [],
  }) : _path = parseSvgPathData(strPath);

  /// transforms a [_path] into [transformedPath] using given [matrix]
  void transform(Matrix4 matrix) {
    transformedPath = _path.transform(matrix.storage);
    for (final room in rooms) {
      room.transform(matrix);
    }
  }

  final Path _path;
  Path? transformedPath;
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final bool isSelectable;
  final int id;
  final List<MapShape> rooms;

  static const double ROOM_VISIBILITY_THRESHOLD = 2;
}
