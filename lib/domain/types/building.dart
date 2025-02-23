import 'package:aitapp/domain/types/room.dart';

class Building {
  Building({
    required this.id,
    required this.name,
    this.rooms,
  });
  factory Building.fromJson(Map<String, dynamic> json) {
    if (json['rooms'] != null) {
      final roomsMap = <String, List<Room>>{};
      json['rooms'].forEach((floor, rooms) {
        roomsMap[floor as String] = (rooms as List)
            .map((room) => Room.fromJson(room as Map<String, dynamic>))
            .toList();
      });
      return Building(
        id: int.parse(json['id'] as String),
        name: json['name'] as String,
        rooms: roomsMap,
      );
    } else {
      return Building(
        id: int.parse(json['id'] as String),
        name: json['name'] as String,
      );
    }
  }
  final int id;
  final String name;
  final Map<String, List<Room>>? rooms;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
