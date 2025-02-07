import 'package:aitapp/domain/types/class.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TimetableDatabase {
  TimetableDatabase._init();
  static final TimetableDatabase instance = TimetableDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('timetable.db');
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
      CREATE TABLE timetable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER NOT NULL,
        semester TEXT NOT NULL,
        day_of_week TEXT NOT NULL,
        period INTEGER NOT NULL,
        title TEXT NOT NULL,
        classroom TEXT NOT NULL,
        teacher TEXT NOT NULL
      )
    ''');
  }

  Future<void> saveTimetable(
    Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> timetable,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      // 既存のデータを削除
      await txn.delete('timetable');

      // 新しいデータを挿入
      for (final yearEntry in timetable.entries) {
        final year = yearEntry.key;
        for (final semesterEntry in yearEntry.value.entries) {
          final semester = semesterEntry.key;
          for (final dayEntry in semesterEntry.value.entries) {
            final dayOfWeek = dayEntry.key;
            for (final periodEntry in dayEntry.value.entries) {
              final period = periodEntry.key;
              final classData = periodEntry.value;

              await txn.insert('timetable', {
                'year': year,
                'semester': semester.name,
                'day_of_week': dayOfWeek.name,
                'period': period,
                'title': classData.title,
                'classroom': classData.classRoom,
                'teacher': classData.teacher,
              });
            }
          }
        }
      }
    });
  }

  Future<void> deleteTimetable() async {
    final db = await database;
    await db.delete('timetable');
  }

  Future<Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>>
      getTimetable() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timetable');

    final timetable = <int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>{};

    for (final row in maps) {
      final year = row['year'] as int;
      final semester = Semester.values.firstWhere(
        (s) => s.name == row['semester'],
      );
      final dayOfWeek = DayOfWeek.values.firstWhere(
        (d) => d.name == row['day_of_week'],
      );
      final period = row['period'] as int;

      timetable.putIfAbsent(year, () => {});
      timetable[year]!.putIfAbsent(semester, () => {});
      timetable[year]![semester]!.putIfAbsent(dayOfWeek, () => {});

      timetable[year]![semester]![dayOfWeek]![period] = Class(
        title: row['title'] as String,
        classRoom: row['classroom'] as String,
        teacher: row['teacher'] as String,
      );
    }

    return timetable;
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
