class UnivNotice {
  UnivNotice(
    this.sender,
    this.title,
    this.content,
    this.sendAt,
    this.url,
    this.files,
  );
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 内容
  final List<String> content;
  // 送信日時
  final String sendAt;

  final List<String> url;

  final Map<String, String>? files;
}
