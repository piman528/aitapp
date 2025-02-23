class Room {
  Room({
    required this.roomId,
    required this.roomName,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'] as String,
      roomName: json['roomName'] as String,
    );
  }
  final String roomId;
  final String roomName;

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomName': roomName,
    };
  }
}
