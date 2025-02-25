import 'package:aitapp/domain/types/assignment_event.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/class_period.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EventDatabase {
  EventDatabase._init();
  static final EventDatabase instance = EventDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        location TEXT,
        teacher TEXT,
        period TEXT,
        course_id INTEGER,
        course_name TEXT,
        description TEXT,
        status TEXT
      )
    ''');
  }

  Future<bool> _existsSimilarEvent(CalendarEvent event) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'title = ? AND start_time = ? AND end_time = ?',
      whereArgs: [
        event.title,
        event.startTime.toIso8601String(),
        event.endTime.toIso8601String(),
      ],
    );
    return maps.isNotEmpty;
  }

  Future<int> insertUnivEvent(UnivEvent event) async {
    // 同じ予定が存在する場合は挿入しない
    if (await _existsSimilarEvent(event)) {
      return -1;
    }

    final db = await database;

    final data = {
      'type': 'univ',
      'title': event.title,
      'start_time': event.startTime.toIso8601String(),
      'end_time': event.endTime.toIso8601String(),
      'location': event.location,
      'teacher': event.teacher,
      'period': event.period?.toString(),
    };

    return db.insert('events', data);
  }

  Future<int> insertAssignmentEvent(AssignmentEvent event) async {
    // 同じ予定が存在する場合は挿入しない
    if (await _existsSimilarEvent(event)) {
      return -1;
    }

    final db = await database;

    final data = {
      'type': 'assignment',
      'title': event.title,
      'start_time': event.startTime.toIso8601String(),
      'end_time': event.endTime.toIso8601String(),
      'course_id': event.courseId,
      'course_name': event.courseName,
      'description': event.description,
      'status': event.status.toString(),
    };

    return db.insert('events', data);
  }

  Future<int> insertCalendarEvent(CalendarEvent event) async {
    // 既に派生クラスである場合は適切なメソッドにリダイレクト
    if (event is UnivEvent) {
      return insertUnivEvent(event);
    } else if (event is AssignmentEvent) {
      return insertAssignmentEvent(event);
    }

    // 同じ予定が存在する場合は挿入しない
    if (await _existsSimilarEvent(event)) {
      return -1;
    }

    final db = await database;

    final data = {
      'type': 'calendar',
      'title': event.title,
      'start_time': event.startTime.toIso8601String(),
      'end_time': event.endTime.toIso8601String(),
      // 他のフィールドはnull
    };

    return db.insert('events', data);
  }

  Future<bool> hasEvents() async {
    final db = await database;
    final result = await db.query(
      'events',
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<Map<DateTime, List<CalendarEvent>>> getAllEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return _convertToEvents(maps);
  }

  Future<Map<DateTime, List<CalendarEvent>>> getEventsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'start_time >= ? AND end_time <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return _convertToEvents(maps);
  }

  Map<DateTime, List<CalendarEvent>> _convertToEvents(
      List<Map<String, dynamic>> maps) {
    final events = maps.map((map) {
      final type = map['type'] as String;

      if (type == 'univ') {
        return UnivEvent(
          title: map['title'] as String,
          startTime: DateTime.parse(map['start_time'] as String),
          endTime: DateTime.parse(map['end_time'] as String),
          location: map['location'] as String?,
          teacher: map['teacher'] as String?,
          period: map['period'] != null
              ? ClassPeriod.values.firstWhere(
                  (p) => p.toString() == map['period'],
                )
              : null,
        );
      } else if (type == 'assignment') {
        return AssignmentEvent(
          title: map['title'] as String,
          startTime: DateTime.parse(map['start_time'] as String),
          endTime: DateTime.parse(map['end_time'] as String),
          courseId: map['course_id'] as int,
          courseName: map['course_name'] as String,
          description: map['description'] as String,
          status: SubmissionStatus.values.firstWhere(
            (s) => s.toString() == map['status'],
          ),
        );
      } else if (type == 'calendar') {
        return CalendarEvent(
          title: map['title'] as String,
          startTime: DateTime.parse(map['start_time'] as String),
          endTime: DateTime.parse(map['end_time'] as String),
        );
      } else {
        throw Exception('Unknown event type: $type');
      }
    }).toList();

    // 日付ごとにイベントをグループ化
    final eventsByDate = <DateTime, List<CalendarEvent>>{};
    for (var event in events) {
      final date = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      if (!eventsByDate.containsKey(date)) {
        eventsByDate[date] = [];
      }
      eventsByDate[date]!.add(event);
    }
    return eventsByDate;
  }

  Future<int> updateUnivEvent(int id, UnivEvent event) async {
    final db = await database;

    final data = {
      'type': 'univ',
      'title': event.title,
      'start_time': event.startTime.toIso8601String(),
      'end_time': event.endTime.toIso8601String(),
      'location': event.location,
      'teacher': event.teacher,
      'period': event.period?.toString(),
    };

    return db.update(
      'events',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateAssignmentEvent(int id, AssignmentEvent event) async {
    final db = await database;

    final data = {
      'type': 'assignment',
      'title': event.title,
      'start_time': event.startTime.toIso8601String(),
      'end_time': event.endTime.toIso8601String(),
      'course_id': event.courseId,
      'course_name': event.courseName,
      'description': event.description,
      'status': event.status.toString(),
    };

    return db.update(
      'events',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateCalendarEvent(int id, CalendarEvent event) async {
    // 既に派生クラスである場合は適切なメソッドにリダイレクト
    if (event is UnivEvent) {
      return updateUnivEvent(id, event);
    } else if (event is AssignmentEvent) {
      return updateAssignmentEvent(id, event);
    }

    final db = await database;

    final data = {
      'type': 'calendar',
      'title': event.title,
      'start_time': event.startTime.toIso8601String(),
      'end_time': event.endTime.toIso8601String(),
    };

    return db.update(
      'events',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllEvents() async {
    final db = await database;
    await db.delete('events');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
