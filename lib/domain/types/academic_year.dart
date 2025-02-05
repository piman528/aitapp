class AcademicYear {
  const AcademicYear._(this.year);
  final int year;

  /// 現在の学年度を取得します
  static int getCurrent() {
    final now = DateTime.now();
    final year = now.month >= 4 ? now.year : now.year - 1;
    return year;
  }

  /// 指定された年の学年度を取得します
  static AcademicYear of(int year) {
    return AcademicYear._(year);
  }

  /// 表示用の年度文字列を取得します (例: "2024年度")
  String get displayName => '$year年度';

  /// 学年度の開始日を取得します
  DateTime get startDate => DateTime(year, 4, 1);

  /// 学年度の終了日を取得します
  DateTime get endDate => DateTime(year + 1, 3, 31);

  /// 指定された日付がこの学年度に含まれるかどうかを判定します
  bool contains(DateTime date) {
    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)));
  }

  @override
  String toString() => 'AcademicYear($year)';
}
