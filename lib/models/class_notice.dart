import 'package:aitapp/models/notice.dart';

class ClassNotice extends Notice {
  ClassNotice({
    required super.sender,
    required super.title,
    required super.isInportant,
    required this.subject,
    this.makeupClassAt,
  });
  // 教科
  final String subject;
  // 補講日日付
  final String? makeupClassAt;
}
