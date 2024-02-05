class SyllabusFilters {
  SyllabusFilters({
    required this.year,
    required this.folder,
    required this.campus,
    required this.hour,
    required this.week,
    required this.semester,
  });
  final Map<String, String> year;
  final Map<String, String> folder;
  final Map<String, String> campus;
  final Map<String, String> week;
  final Map<String, String> hour;
  final Map<String, String> semester;
}
