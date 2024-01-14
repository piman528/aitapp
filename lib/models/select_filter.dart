class SelectFilters {
  SelectFilters({
    required this.year,
    this.folder,
    this.campus,
    this.hour,
    this.week,
    this.semester,
  });
  final String year;
  final String? folder;
  final String? campus;
  final String? week;
  final String? hour;
  final String? semester;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SelectFilters &&
        other.year == year &&
        other.folder == folder &&
        other.campus == campus &&
        other.semester == semester &&
        other.week == week &&
        other.hour == hour;
  }

  @override
  int get hashCode =>
      year.hashCode ^
      folder.hashCode ^
      campus.hashCode ^
      semester.hashCode ^
      week.hashCode ^
      hour.hashCode;
}
