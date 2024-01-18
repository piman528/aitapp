// ignore_for_file: lines_longer_than_80_chars

import 'package:aitapp/const.dart';
import 'package:aitapp/models/class.dart';
import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/syllabus_filter.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:http/http.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/parsing.dart';

final _regexSplitSetCookies = RegExp(',(?=[^ ])');

List<ClassNotice> parseClassNotice(String body) {
  final classNoticeList = <ClassNotice>[];
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    '#smartPhoneClassContactList > form:nth-child(4) > div.listItem',
  );

  if (topStorytitle.isEmpty) {
    throw Exception('[parseClassNotice]データの取得に失敗しました');
  }

  for (final div in topStorytitle) {
    final texts = <String>[];
    final contents =
        div.querySelector('> table > tbody > tr > td:nth-child(1)');
    for (final text in contents!.text!.replaceAll('	', '').trim().split('\n')) {
      if (text != '') {
        texts.add(text);
      }
    }
    var c = 0;
    var sender = '';
    var title = '';
    const content = <String>[];
    const sendAt = '';
    var subject = '';
    var makeupClassAt = '';
    for (final text in texts) {
      switch (c) {
        case 2: // 授業科目
          subject = text;
        case 6: // タイトル
          if (text == '重要') {
            continue;
          }
          title = text;
        case 7: // 講師名
          sender = text;
        case 10: // 補講日日付
          makeupClassAt = text;
      }
      c++;
    }
    classNoticeList.add(
      ClassNotice(sender, title, content, sendAt, subject, makeupClassAt, []),
    );
  }
  return classNoticeList;
}

ClassNotice parseClassNoticeDetail(String body) {
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr',
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseClassNoticeDetail]データの取得に失敗しました');
  }
  final texts = <String>[];
  var isMaincontent = false;
  for (final tr in topStorytitle) {
    if (!isMaincontent) {
      final contents = tr.text!.replaceAll('	', '').trim().split('\n');
      for (final text in contents) {
        if (text != '') {
          texts.add(text);
        }
      }
    } else {
      final maincontents = tr.querySelector('td > div')!.nodes;
      for (final mainContent in maincontents) {
        if (mainContent.nodeType == html.Node.ELEMENT_NODE) {
          for (final childNode in mainContent.childNodes) {
            final text = childNode.text!.trim();
            if (text != '') {
              texts.add(text);
            }
          }
        }
      }
      isMaincontent = false;
    }
    if (texts.last == '内容') {
      isMaincontent = true;
    }
  }
  final subject = texts[texts.indexOf('授業科目') + 1];
  final sender = texts[texts.indexOf('授業科目') + 3];
  final titleindex = texts.indexOf('タイトル') + 1;
  final title =
      texts[titleindex] != '重要' ? texts[titleindex] : texts[titleindex + 1];
  final content = <String>[];
  for (var i = texts.indexOf('内容') + 1; i < texts.indexOf('ファイル'); i++) {
    content.add(texts[i]);
  }
  final sendAt = texts[texts.indexOf('連絡日時') + 1];
  final url = <String>[];
  for (var i = texts.indexOf('参考URL') + 1; i < texts.indexOf('連絡日時'); i++) {
    url.add(texts[i]);
  }
  return ClassNotice(sender, title, content, sendAt, subject, '', url);
}

List<UnivNotice> parseUnivNotice(String body) {
  final univNoticeList = <UnivNotice>[]; //return
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    '#smartPhoneCommonContactList > form:nth-child(4) > div.listItem',
  ); //記事のリスト
  if (topStorytitle.isEmpty) {
    throw Exception('[parseUnivNotice]データの取得に失敗しました');
  }

  for (final parentDiv in topStorytitle) {
    final texts = <String>[];
    final td = parentDiv.querySelector(
      'table > tbody > tr > td',
    );
    for (final text in td!.text!.replaceAll('	', '').trim().split('\n')) {
      if (text != '') {
        texts.add(text);
      }
    }
    var c = 0;
    var sender = '';
    var title = '';
    const content = <String>[];
    var sendAt = '';
    // var subject = '';
    // var makeupClassAt = '';
    for (final text in texts) {
      switch (c) {
        case 0: // タイトル
          if (text == '重要') {
            continue;
          }
          title = text;
        case 1: // 送信者
          sender = text;
        case 2: // 日付
          sendAt = text;
      }
      c++;
    }
    univNoticeList
        .add(UnivNotice(sender, title, content, sendAt, [], {'': ''}));
  }
  return univNoticeList;
}

UnivNotice parseUnivNoticeDetail(String body) {
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr',
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseUnivNoticeDetail]データの取得に失敗しました');
  }
  final texts = <String>[];
  var mainContent = 0;
  final fileMap = <String, String>{};
  for (final tr in topStorytitle) {
    if (mainContent == 0 || mainContent == 2) {
      final contents = tr.text!.replaceAll('	', '').trim().split('\n');
      for (final text in contents) {
        if (text != '') {
          texts.add(text);
          // print(text);
        }
      }
    } else if (mainContent == 1) {
      final maincontents = tr.querySelector('td > div')!.nodes;
      for (final mainContent in maincontents) {
        if (mainContent.nodeType == html.Node.ELEMENT_NODE) {
          for (final childNode in mainContent.childNodes) {
            final text = childNode.text!.trim();
            if (text != '') {
              texts.add(text);
              // print(text);
            }
          }
        }
      }
      mainContent = 0;
    }
    if (mainContent == 2) {
      if (texts.last != '参考URL') {
        final maincontents = tr.querySelectorAll('td > div');
        for (final childContents in maincontents) {
          for (final content in childContents.querySelectorAll('div > a')) {
            fileMap.addEntries(
              [
                MapEntry(
                  content.text!.trim(),
                  content.attributes['href']!,
                ),
              ],
            );
          }
        }
      }
      mainContent = 0;
    }
    switch (texts.last) {
      case '連絡内容':
        mainContent = 1;
      case '添付ファイル':
        mainContent = 2;
    }
  }
  final sender = texts[texts.indexOf('管理所属') + 1];
  final titleindex = texts.indexOf('タイトル') + 1;
  final title =
      texts[titleindex] != '重要' ? texts[titleindex] : texts[titleindex + 1];
  final content = <String>[];
  for (var i = texts.indexOf('連絡内容') + 1; i < texts.indexOf('連絡元'); i++) {
    content.add(texts[i]);
  }
  final sendAt = texts[texts.indexOf('連絡日時') + 1];
  final url = <String>[];
  for (var i = texts.indexOf('参考URL') + 1; i < texts.indexOf('連絡日時'); i++) {
    url.add(texts[i]);
  }
  return UnivNotice(sender, title, content, sendAt, url, fileMap);
}

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

SyllabusFilters parseSyllabusFilters(Response res) {
  final topStorytitle = parseHtmlDocument(res.body).querySelectorAll(
    'body > form > table:nth-child(1) > tbody > tr > td > table > tbody > tr',
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseSyllabusList]データの取得に失敗しました');
  }
  final year = <String, String>{};
  final faculty = <String, String>{};
  final campus = <String, String>{};
  final hour = <String, String>{};
  final week = <String, String>{};
  final semester = <String, String>{};
  for (final tr in topStorytitle) {
    final filterstring = tr.querySelector('td:nth-child(1)')!.text!.trim();
    switch (filterstring) {
      case '年度':
        final filterlists =
            tr.querySelectorAll('td:nth-child(2) > div > select > option');
        var i = 0;
        for (final option in filterlists) {
          if (i == 0) {
            i++;
            continue;
          }
          year[option.text!] = option.attributes['value']!;
        }
      case 'フォルダ':
        final filterlists =
            tr.querySelectorAll('td:nth-child(2) > div > select > option');
        var i = 0;
        for (final option in filterlists) {
          if (i == 0) {
            i++;
            continue;
          }
          faculty[option.text!] = option.attributes['value']!;
        }
      case '校舎区分':
        final filterlists =
            tr.querySelectorAll('td:nth-child(2) > div > select > option');
        var i = 0;
        for (final option in filterlists) {
          if (i == 0) {
            i++;
            continue;
          }
          campus[option.text!] = option.attributes['value']!;
        }
      case '曜日':
        final filterlists =
            tr.querySelectorAll('td:nth-child(2) > div > select > option');
        var i = 0;
        for (final option in filterlists) {
          if (i == 0) {
            i++;
            continue;
          }
          week[option.text!] = option.attributes['value']!;
        }
      case '時限':
        final filterlists =
            tr.querySelectorAll('td:nth-child(2) > div > select > option');
        var i = 0;
        for (final option in filterlists) {
          if (i == 0) {
            i++;
            continue;
          }
          hour[option.text!] = option.attributes['value']!;
        }
      case '開講学期':
        final filterlists =
            tr.querySelectorAll('td:nth-child(2) > div > select > option');
        var i = 0;
        for (final option in filterlists) {
          if (i == 0) {
            i++;
            continue;
          }
          semester[option.text!] = option.attributes['value']!;
        }
    }
  }
  final cookies = <String>[];
  final setCookie = _getSetCookie(res.headers);
  if (setCookie.isNotEmpty) {
    for (final cookie in setCookie.split(_regexSplitSetCookies)) {
      cookies.add(cookie.split(';')[0]);
    }
  }

  return SyllabusFilters(
    year: year,
    folder: faculty,
    campus: campus,
    cookies: cookies,
    hour: hour,
    week: week,
    semester: semester,
  );
}

List<ClassSyllabus> parseSyllabus(String body) {
  final classSyllabusList = <ClassSyllabus>[];
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table:nth-child(2) > tbody > tr > td > table > tbody > tr',
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseSyllabusList]データの取得に失敗しました');
  }
  var i = 0;
  for (final tr in topStorytitle) {
    if (i == 0) {
      i++;
      continue;
    }
    //授業単位
    final texts = <String>[];
    for (final text in tr.text!.replaceAll('	', '').trim().split('\n')) {
      if (text != '') {
        texts.add(text);
      }
    }
    final url = tr
        .querySelector(
          'td > a',
        )!
        .attributes['onclick']!
        .split("'")[1];
    var c = 0;
    // 単位数
    var unitsNumber = 0;
    // 区分
    var classification = Classification.required;
    // 教員名
    var teacher = '';
    // 教科
    var subject = '';
    for (final text in texts) {
      switch (c) {
        case 3: //教科
          subject = text.trim();
        case 4: // 教員
          teacher = text.trim();
        case 10: // 単位数
          unitsNumber = int.parse(text);
        case 9: //区分
          switch (text.trim()) {
            case '選必':
              classification = Classification.requiredElective;
            case '選択':
              classification = Classification.choice;
            case '必修':
              classification = Classification.required;
          }
      }
      c++;
    }
    classSyllabusList.add(
      ClassSyllabus(
        unitsNumber,
        classification,
        teacher,
        subject,
        url,
      ),
    );
    i++;
  }
  return classSyllabusList;
}

ClassSyllabusDetail parseSyllabusDetail(String body) {
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > table:nth-child(16) > tbody > tr > td > table > tbody > tr',
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseSyllabus]データの取得に失敗しました');
  }
  final texts = <String>[];
  for (final tr in topStorytitle) {
    final tds = tr.querySelectorAll('td');
    var index = 0;
    for (final tdtext in tds) {
      if (index == 0) {
        for (final text in tdtext.text!
            .replaceAll('	', '')
            .replaceAll(' ', '')
            .trim()
            .split('\n')) {
          if (text != '' && text != ' ') {
            texts.add(text);
            if (text == '計画') {
              index = 1;
            }
          }
        }
      } else {
        final contents = tdtext.nodes;
        for (final content in contents) {
          final text = content.text!.trim();
          if (text != '') {
            texts.add(text);
          }
        }
        index = 0;
      }
    }
  }
  // print(texts);
  final unitsNumber = texts[texts.indexOf('単位数') + 1];
  final classification = texts[texts.indexOf('単位区分') + 1] == '選択'
      ? Classification.choice
      : texts[texts.indexOf('単位区分') + 1] == '必修'
          ? Classification.required
          : Classification.requiredElective;
  final teacher = <String>[];
  for (var i = texts.indexOf('担当教員') + 1;
      i < texts.indexOf('研究室・オフィスアワー');
      i++) {
    teacher.add(texts[i]);
  }
  final subject = texts[texts.indexOf('科目名') + 3];
  final classPeriod = texts[texts.indexOf('曜日・時限') + 1];
  final classRoom = texts[texts.indexOf('講義室（キャンパス）') + 1] != '開講学期'
      ? texts[texts.indexOf('講義室（キャンパス）') + 1]
      : '';
  final semester = texts[texts.indexOf('開講学期') + 1];
  final content = texts[texts.indexOf('概要') + 1];
  final plan = <String>[];
  for (var i = texts.indexOf('計画') + 1; i < texts.indexOf('教科書'); i++) {
    plan.add(texts[i]);
  }
  final learningGoal = texts[texts.indexOf('学習到達目標') + 1];
  final feature = texts[texts.indexOf('方法と特徴') + 1];
  final record = texts[texts.indexOf('成績評価の方法') + 1];
  final teachersMessage =
      texts[texts.indexOf('教員からのメッセージ') + 1] != '添付ファイル(5MBまで）'
          ? texts[texts.indexOf('教員からのメッセージ') + 1]
          : '';
  return ClassSyllabusDetail(
    int.parse(unitsNumber),
    classification,
    teacher,
    semester,
    [content],
    subject,
    classPeriod,
    classRoom,
    plan,
    learningGoal,
    feature,
    record,
    teachersMessage,
  );
}

String parseStrutsToken({
  required String body,
  required bool isCommon,
}) {
  String selector;
  if (isCommon) {
    selector =
        '#smartPhoneCommonContactList > form:nth-child(3) > div:nth-child(1) > input';
  } else {
    selector =
        '#smartPhoneClassContactList > form:nth-child(3) > div:nth-child(1) > input';
  }
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    selector,
  );
  if (topStorytitle.isEmpty) {
    throw Exception('[parseStrutsToken]データの取得に失敗しました');
  }
  final value = topStorytitle[0].attributes['value'];
  return value!;
}

String _getSetCookie(Map<String, dynamic> headers) {
  for (final key in headers.keys) {
    // システムによって返却される "set-cookie" のケースはバラバラです。
    if (key.toLowerCase() == 'set-cookie') {
      return headers[key] as String;
    }
  }

  return '';
}
