class ClassNotice {
  ClassNotice(
    this.sender,
    this.title,
    this.content,
    this.sendAt,
    this.subject,
    this.makeupClassAt,
  );
  // 発信者
  final String sender;
  // タイトル
  final String title;
  // 内容
  final String content;
  // 送信日時
  final String sendAt;
  // 教科
  final String subject;
  // 補講日日付
  final String makeupClassAt;
}
