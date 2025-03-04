import 'package:aitapp/domain/types/map_shape.dart';

class MapShapes {
  MapShapes({
    required this.selectableShapes,
    required this.unSelectableShapes,
  });
  final List<MapShape> selectableShapes;
  final List<MapShape> unSelectableShapes;
}
