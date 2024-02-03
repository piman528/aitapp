import 'package:aitapp/models/notice.dart';

class UnivNotice extends Notice {
  UnivNotice({
    required super.sender,
    required super.title,
    required this.sendAt,
  });
  // 送信日時
  final String sendAt;
}
