abstract class Notice {
  Notice({
    required this.sender,
    required this.title,
    required this.isInportant,
  });
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 重要かどうか
  final bool isInportant;
}
