// ignore_for_file: lines_longer_than_80_chars

import 'package:aitapp/const.dart';
import 'package:aitapp/models/class.dart';
import 'package:universal_html/parsing.dart';

Map<DayOfWeek, Map<int, Class>> parseClassTimeTable(String body) {
  final classTimeTableMap = <DayOfWeek, Map<int, Class>>{};
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr',
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseClassTimeTable]データの取得に失敗しました');
  }
  for (var i = 0; i < topStorytitle.length; i++) {
    final day = i ~/ 7;
    final period = i % 7 + 1;
    final contents = topStorytitle[i].querySelector('> td > div')?.nodes;
    final texts = <String>[];
    if (contents != null) {
      for (final node in contents) {
        final text = node.text!.trim();
        if (text != '') {
          texts.add(text);
        }
      }
    }
    var c = 0;
    var subject = '';
    var teacher = '';
    var classRoom = '';
    for (final text in texts) {
      switch (c) {
        case 0: //授業科目
          subject = text.replaceAll('[八]', '');
        case 1: // 教員
          teacher = text;
        case 2: // 教室
          classRoom = text.replaceAll('八草', '').trim();
      }
      c++;
    }
    final dayOfWeek = switch (day) {
      0 => DayOfWeek.monday,
      1 => DayOfWeek.tuesday,
      2 => DayOfWeek.wednesday,
      3 => DayOfWeek.thurstay,
      4 => DayOfWeek.friday,
      5 => DayOfWeek.saturday,
      _ => DayOfWeek.sunday,
    };
    if (subject != '') {
      classTimeTableMap[dayOfWeek] ??= <int, Class>{};
      classTimeTableMap[dayOfWeek]![period] =
          Class(title: subject, classRoom: classRoom, teacher: teacher);
    }
  }
  return classTimeTableMap;
}

String parseStrutsToken({
  required String body,
  required bool isCommon,
}) {
  final selector = isCommon
      ? '#smartPhoneCommonContactList > form:nth-child(3) > div:nth-child(1) > input'
      : '#smartPhoneClassContactList > form:nth-child(3) > div:nth-child(1) > input';
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    selector,
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseStrutsToken]データの取得に失敗しました');
  }
  final value = topStorytitle[0].attributes['value'];
  return value!;
}
