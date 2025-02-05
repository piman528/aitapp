enum Semester {
  early('前期', 1),
  late('後期', 2),
  fullYear('通年', 3);

  const Semester(this.displayName, this.num);
  final String displayName;
  final int num;

  /// 現在の学期を取得します
  static Semester getCurrent() {
    return of(DateTime.now());
  }

  /// 指定された日付の学期を取得します
  static Semester of(DateTime date) {
    return date.month >= 4 && date.month <= 9 ? Semester.early : Semester.late;
  }
}
