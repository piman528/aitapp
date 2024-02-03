import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/syllabus_filter.dart';
import 'package:http/http.dart';
import 'package:universal_html/parsing.dart';

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
    for (final cookie in setCookie.split(RegExp(',(?=[^ ])'))) {
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
  final teacherRuby = <String>[];
  for (var i = texts.indexOf('担当教員') + 1;
      i < texts.indexOf('研究室・オフィスアワー');
      i = i + 2) {
    teacher.add(texts[i]);
    teacherRuby.add(texts[i + 1]);
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
    teacherRuby,
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

String _getSetCookie(Map<String, dynamic> headers) {
  for (final key in headers.keys) {
    // システムによって返却される "set-cookie" のケースはバラバラです。
    if (key.toLowerCase() == 'set-cookie') {
      return headers[key] as String;
    }
  }

  return '';
}
