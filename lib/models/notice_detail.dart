class NoticeDetail {
  NoticeDetail({
    required this.sender,
    required this.title,
    required this.sendAt,
    required this.content,
    required this.files,
    required this.url,
  });
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 内容
  final String content;
  // url
  final List<String> url;
  // ファイルurl
  final Map<String, String> files;
  // 送信日時
  final String sendAt;
}
