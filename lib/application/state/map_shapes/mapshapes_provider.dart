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
    return MapStateData(shapes: [], selectedShapeIds: []);
  }

  Future<void> _load() async {
    final shapes = await SVGLoader().loadSVGMap();
    state = MapStateData(
      shapes: shapes,
      selectedShapeIds: state.selectedShapeIds,
    );
  }

  Future<void> selectShape(int? id) async {
    if (id == null) {
      state = MapStateData(shapes: state.shapes, selectedShapeIds: []);
      return;
    }

    final selectedBuilding = await DatabaseHelper().getBuildingById(id);
    if (selectedBuilding == null) {
      return;
    }
    final selectedIds = await DatabaseHelper()
        .getBuildingIdsByName(buildingName: selectedBuilding.name);

    state = MapStateData(
      shapes: state.shapes,
      selectedShapeIds: selectedIds,
    );
  }
}
