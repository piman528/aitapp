import 'package:aitapp/domain/types/map_state.dart';
import 'package:aitapp/infrastructure/database/db_helper.dart';
import 'package:aitapp/infrastructure/svg_loader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mapshapes_provider.g.dart';

@Riverpod(keepAlive: true)
class MapShapesNotifier extends _$MapShapesNotifier {
  @override
  MapStateData build() {
    _load();
    return MapStateData(shapes: null, selectedShapeId: null);
  }

  Future<void> _load() async {
    final shapes = await SVGLoader().loadSVGMap();
    state = MapStateData(
      shapes: shapes,
      selectedShapeId: state.selectedShapeId,
    );
  }

  Future<void> selectShape(int? id) async {
    // print(id);
    if (id == null) {
      state = MapStateData(shapes: state.shapes, selectedShapeId: null);
      return;
    }

    final selectedBuilding = await DatabaseHelper().getBuildingById(id);
    if (selectedBuilding == null) {
      return;
    }
    final selectedId = await DatabaseHelper()
        .getBuildingIdsByName(buildingName: selectedBuilding.name);

    state = MapStateData(
      shapes: state.shapes,
      selectedShapeId: selectedId,
    );
  }
}
