import 'package:aitapp/domain/types/assignment_event.dart';

class MoodleAssignment {
  MoodleAssignment({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.courseId,
    required this.courseName,
  });

  final int id;
  final String name;
  final String description;
  final DateTime dueDate;
  final int courseId;
  final String courseName;

  /// 課題をカレンダーイベントに変換する
  AssignmentEvent toCalendarEvent() {
    return AssignmentEvent(
      courseId: courseId,
      courseName: courseName,
      description: description,
      status: SubmissionStatus.notSubmitted, // デフォルトは未提出
      title: '【$courseName】$name',
      // 締め切りの24時間前を開始時刻とする
      startTime: dueDate.subtract(const Duration(hours: 24)),
      endTime: dueDate,
    );
  }
}
