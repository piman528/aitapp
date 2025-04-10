enum ClassPeriod {
  period1(1),
  period2(2),
  period3(3),
  period4(4),
  period5(5),
  period6(6),
  period7(7);

  const ClassPeriod(this.num);
  final int num;

  // int から ClassPeriod を取得するための static メソッド
  static ClassPeriod? fromInt(int number) {
    return ClassPeriod.values.firstWhere(
      (period) => period.num == number,
      orElse: () => throw ArgumentError('Invalid period number: $number'),
    );
  }
}
