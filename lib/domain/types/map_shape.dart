import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class MapShape {
  MapShape({
    required List<String> strPathList,
    String? strColision,
    required this.strokeColor,
    required this.strokeWidth,
    this.id,
    this.fillColor,
    this.rooms = const [],
  })  : _pathList = strPathList.map(parseSvgPathData).toList(),
        colisionList = strColision != null
            ? [parseSvgPathData(strColision)]
            : strPathList.map(parseSvgPathData).toList();

  /// transforms a [_pathList] into [transformedPathList] using given [matrix]
  void transform(Matrix4 matrix) {
    transformedPathList =
        _pathList.map((path) => path.transform(matrix.storage)).toList();
    for (final room in rooms) {
      room.transform(matrix);
    }
    transformedColisionList =
        colisionList.map((path) => path.transform(matrix.storage)).toList();
  }

  Rect getBoundingBox() {
    final paths = transformedPathList ?? _pathList;
    if (paths.isEmpty) {
      return Rect.zero;
    }

    Rect? boundingBox;
    for (final path in paths) {
      final pathBounds = path.getBounds();
      boundingBox = boundingBox?.expandToInclude(pathBounds) ?? pathBounds;
    }
    return boundingBox!;
  }

  final List<Path> _pathList;
  final List<Path> colisionList;
  List<Path>? transformedPathList;
  List<Path>? transformedColisionList;
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final int? id;
  final List<MapShape> rooms;

  static const double roomVisibilityThreshold = 2;
}
