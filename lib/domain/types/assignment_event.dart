import 'package:aitapp/domain/types/calendar_event.dart';

/// 課題の提出状態を表す列挙型
enum SubmissionStatus {
  notSubmitted, // 未提出
  submitted, // 提出済み
  needsGrading, // 採点待ち
}

/// 課題イベントを表すクラス
class AssignmentEvent extends CalendarEvent {
  AssignmentEvent({
    required this.courseId,
    required this.courseName,
    required this.description,
    required this.status,
    required super.title,
    required super.startTime,
    required super.endTime,
  });

  /// コースID
  final int courseId;

  /// コース名
  final String courseName;

  /// 課題の説明
  final String description;

  /// 提出状態
  final SubmissionStatus status;

  /// 課題の詳細情報を文字列で返す
  @override
  String toString() {
    return 'AssignmentEvent{'
        'courseId: $courseId, '
        'courseName: $courseName, '
        'title: $title, '
        'description: $description, '
        'status: $status, '
        'startTime: $startTime, '
        'endTime: $endTime'
        '}';
  }
}
