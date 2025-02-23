import 'package:aitapp/domain/types/building.dart';
import 'package:aitapp/domain/types/building_room.dart';
import 'package:aitapp/domain/types/building_room_list.dart';
import 'package:aitapp/infrastructure/database/db_helper.dart';

class SearchBuildingUsecase {
  final db = DatabaseHelper();
  Future<List<BuildingRoom>> searchRooms(String searchWord) async {
    final buildingList = await db.searchRoom(searchWord);
    return buildingList
        .map(
          (building) => BuildingRoom(
            id: int.parse(building['id'] as String),
            roomName: building['roomName'] as String,
            buildingName: building['buildingName'] as String,
            floor: building['floor'] as String,
            roomId: int.parse(
              building['roomId'] as String,
            ),
          ),
        )
        .toList();
  }

  Future<List<Building>> searchBuildings(String searchWord) async {
    final buildingList = await db.searchBuilding(searchWord);
    return buildingList.map((building) {
      return Building(
        id: int.parse(building['id'] as String),
        name: building['buildingName'] as String,
      );
    }).toList();
  }

  Future<BuildingRoomList> searchBuildingRoom(String searchWord) async {
    final roomList = await searchRooms(searchWord);
    final buildingList = await searchBuildings(searchWord);

    return BuildingRoomList(buildings: buildingList, rooms: roomList);
  }
}
