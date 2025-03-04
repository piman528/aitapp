import 'package:aitapp/domain/types/map_shape.dart';
import 'package:aitapp/domain/types/map_shapes.dart';
import 'package:collection/collection.dart';

class MapStateData {
  MapStateData({
    required this.shapes,
    required this.selectedShapeId,
  });
  final MapShapes? shapes;
  final int? selectedShapeId;

  MapShape? getSelectedShapes() {
    return shapes?.selectableShapes
        .firstWhereOrNull((shape) => shape.id == selectedShapeId);
  }

  String? getSelectedBuildingName() {
    if (selectedShapeId == null) {
      return null;
    }
    final firstSelectedShape = shapes?.selectableShapes
        .firstWhereOrNull((shape) => shape.id == selectedShapeId);
    return firstSelectedShape?.id.toString();
  }
}
