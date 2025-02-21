import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/infrastructure/restaccess/access_moodle.dart';

class GetMoodleData {
  final _moodleClient = MoodleApiClient();
  late final String _token;

  Future<void> create(String username, String password) async {
    _token = await _moodleClient.getToken(
      username: username,
      password: password,
    );
  }

  Future<Map<DateTime, List<CalendarEvent>>> getAssignments() async {
    // Moodleから課題を取得

    final assignments = await _moodleClient.getAssignments(
      token: _token,
    );

    // 課題をカレンダーイベントに変換し、日付ごとにグループ化
    final eventMap = <DateTime, List<CalendarEvent>>{};

    for (final assignment in assignments) {
      final event = assignment.toCalendarEvent();
      final normalizedDate = DateTime(
        event.endTime.year,
        event.endTime.month,
        event.endTime.day,
      );

      if (eventMap[normalizedDate] == null) {
        eventMap[normalizedDate] = [];
      }
      eventMap[normalizedDate]!.add(event);
    }

    return eventMap;
  }
}
