import 'package:aitapp/domain/types/building.dart';
import 'package:aitapp/domain/types/building_room.dart';

class BuildingRoomList {
  BuildingRoomList({
    required this.buildings,
    required this.rooms,
  });
  final List<Building> buildings;
  final List<BuildingRoom> rooms;
}
