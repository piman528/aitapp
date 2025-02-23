import 'package:aitapp/domain/types/map_shape.dart';
import 'package:collection/collection.dart';

class MapStateData {
  MapStateData({
    required this.shapes,
    List<int>? selectedShapeIds,
  }) : selectedShapeIds = selectedShapeIds ?? [];
  final List<MapShape> shapes;
  final List<int> selectedShapeIds;

  List<MapShape> getSelectedShapes() {
    return shapes
        .where((shape) => selectedShapeIds.contains(shape.id))
        .toList();
  }

  String? getSelectedBuildingName() {
    if (selectedShapeIds.isEmpty) {
      return null;
    }
    final firstSelectedShape =
        shapes.firstWhereOrNull((shape) => shape.id == selectedShapeIds.first);
    return firstSelectedShape?.id.toString();
  }
}
