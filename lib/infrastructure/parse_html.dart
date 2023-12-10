import 'package:aitapp/const.dart';
import 'package:aitapp/models/class.dart';
import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/parsing.dart';

List<ClassNotice> parseClassNotice(String body) {
  final classNoticeList = <ClassNotice>[];
  final document = parseHtmlDocument(body);
  final topStorytitle = document.querySelectorAll(
    '#smartPhoneClassContactList > form:nth-child(4) > div.listItem',
  );

  for (final element in topStorytitle) {
    final noticesParse =
        element.querySelector('> table > tbody > tr > td:nth-child(1)');
    final childNodes = noticesParse?.nodes;
    final texts = <String>[];
    for (final node in childNodes!) {
      if (node.nodeType == html.Node.TEXT_NODE) {
        final spaceTrimTextList =
            node.text!.replaceAll('	', '').trim().split('\n');
        // print(spaceTrimTextList);
        for (final line in spaceTrimTextList) {
          texts.add(line);
        }
      }
    }
    var c = 0;
    var sender = '';
    var title = '';
    const content = <String>[];
    const sendAt = '';
    var subject = '';
    var makeupClassAt = '';
    var isNotInportant = false;
    for (final text in texts) {
      if (c == 6 && text == '') {
        isNotInportant = true;
      }
      if (isNotInportant) {
        //重要でない場合
        switch (c) {
          case 7: // タイトル
            title = text;
          case 8: // 講師名
            sender = text;
          case 9: // 補講日日付
            makeupClassAt = text;
        }
      } else {
        switch (c) {
          // case 0: //「授業科目」
          //   break;
          // case 1: // コロン
          //   break;
          case 2: // 授業科目
            subject = text;
          case 3: // 授業時間割
            break;
          // case 4: // 「タイトル」
          //   break;
          // case 5: // コロン
          //   break;
          case 6: // タイトル
            title = text;
          case 7: // 講師名
            sender = text;
          // case 8: // 「補講日」
          //   break;
          // case 9: // コロン
          //   break;
          case 10: // 補講日日付
            makeupClassAt = text;
        }
      }
      c++;
    }
    classNoticeList.add(
      ClassNotice(sender, title, content, sendAt, subject, makeupClassAt),
    );
  }
  return classNoticeList;
}

ClassNotice parseClassNoticeDetail(String body) {
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr > td',
  );
  final texts = <String>[];
  for (final element in topStorytitle) {
    final noticeDetailChildNodes = element.nodes;
    for (final node in noticeDetailChildNodes) {
      if (node.nodeType == html.Node.TEXT_NODE) {
        final spaceTrimTextList = node.text!
            .replaceAll('	', '')
            .replaceAll('', '')
            .trim()
            .split('\n');
        for (final line in spaceTrimTextList) {
          if (line != '') {
            texts.add(line);
          }
        }
      }
    }
  }
  final parseContentBody = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr > td > div > div',
  );
  for (final contentElement in parseContentBody) {
    final noticeContentChildNodes = contentElement.nodes;
    for (final node in noticeContentChildNodes) {
      if (node.nodeType == html.Node.TEXT_NODE) {
        final spaceTrimTextList = node.text!
            .replaceAll('	', '')
            .replaceAll('', '')
            .trim()
            .split('\n');
        for (final line in spaceTrimTextList) {
          if (line != '') {
            texts.add(line);
          }
        }
      }
    }
  }
  var c = 0;
  var subject = '';
  var sender = '';
  var title = '';
  final content = <String>[];
  var sendAt = '';
  for (final text in texts) {
    // print('$text $c');
    switch (c) {
      case 0: // 教科
        subject = text;
      case 1: // 授業時間
      // title = text;
      case 2: // 送信者
        sender = text;
      case 3: // タイトル
        title = text;
      case 4: //日付
        sendAt = text;
      case 5: //時間
        sendAt = '$sendAt $text';
    }
    if (c >= 8) {
      content.add(text);
    }
    c++;
  }
  // print(title);
  return ClassNotice(sender, title, content, sendAt, subject, '');
}

List<UnivNotice> parseUnivNotice(String body) {
  final univNoticeList = <UnivNotice>[]; //return
  final document = parseHtmlDocument(body);
  final topStorytitle = document.querySelectorAll(
    '#smartPhoneCommonContactList > form:nth-child(4) > div.listItem',
  ); //記事のリスト

  for (final element in topStorytitle) {
    final noticeParse =
        element.querySelector('> table > tbody > tr > td:nth-child(1)');
    final noticeChildNodes = noticeParse?.nodes;
    final texts = <String>[];
    for (final node in noticeChildNodes!) {
      if (node.nodeType == html.Node.TEXT_NODE) {
        final spaceTrimTextList =
            node.text!.replaceAll('	', '').trim().split('\n');
        for (final line in spaceTrimTextList) {
          if (line != '') {
            texts.add(line);
          }
        }
      } else if (node.nodeType == html.Node.ELEMENT_NODE) {
        final childDocument = parseHtmlDocument('$node');
        final childElements = childDocument.querySelectorAll('> div > div');
        for (final childElement in childElements) {
          final childNodes = childElement.nodes;
          for (final childNode in childNodes) {
            if (childNode.nodeType == html.Node.TEXT_NODE) {
              final spaceTrimTextList =
                  childNode.text!.replaceAll('	', '').trim().split('\n');
              for (final line in spaceTrimTextList) {
                if (line != '') {
                  texts.add(line);
                }
              }
            }
          }
        }
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
      // debugPrint('$text $c');
      switch (c) {
        case 0: // タイトル
          title = text;
        case 1: // 送信者
          sender = text;
        case 2: // 日付
          sendAt = text;
      }
      c++;
    }
    univNoticeList.add(UnivNotice(sender, title, content, sendAt));
  }
  return univNoticeList;
}

UnivNotice parseUnivNoticeDetail(String body) {
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr > td',
  );
  final texts = <String>[];
  for (final element in topStorytitle) {
    final noticeDetailChildNodes = element.nodes;
    for (final node in noticeDetailChildNodes) {
      if (node.nodeType == html.Node.TEXT_NODE) {
        final spaceTrimTextList = node.text!
            .replaceAll('	', '')
            .replaceAll('', '')
            .trim()
            .split('\n');
        for (final line in spaceTrimTextList) {
          if (line != '') {
            texts.add(line);
          }
        }
      }
    }
  }
  final parseContentBody = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr > td > div > div',
  );
  for (final contentElement in parseContentBody) {
    final noticeContentChildNodes = contentElement.nodes;
    for (final node in noticeContentChildNodes) {
      if (node.nodeType == html.Node.TEXT_NODE) {
        final spaceTrimTextList = node.text!
            .replaceAll('	', '')
            .replaceAll('', '')
            .trim()
            .split('\n');
        for (final line in spaceTrimTextList) {
          if (line != '') {
            texts.add(line);
          }
        }
      }
    }
  }
  var c = 0;
  var sender = '';
  var title = '';
  final content = <String>[];
  var sendAt = '';
  for (final text in texts) {
    switch (c) {
      case 1: // タイトル
        title = text;
      case 2: // 送信者
        sender = text;
      case 3: // 日付
        sendAt = text;
    }
    if (c >= 7) {
      content.add(text);
    }
    c++;
  }
  return UnivNotice(sender, title, content, sendAt);
}

Map<DayOfWeek, Map<int, Class>> parseClassTimeTable(String body) {
  final classTimeTableMap = <DayOfWeek, Map<int, Class>>{};
  final topStorytitle = parseHtmlDocument(body).querySelectorAll(
    'body > form > table > tbody > tr',
  );
  for (var i = 0; i < topStorytitle.length; i++) {
    final day = i ~/ 7;
    final period = i % 7 + 1;
    final classesParse = topStorytitle[i].querySelector('> td > div');
    final childNodes = classesParse?.nodes;
    final texts = <String>[];
    if (childNodes != null) {
      for (final node in childNodes) {
        if (node.nodeType == html.Node.TEXT_NODE) {
          final spaceTrimTextList =
              node.text!.replaceAll('	', '').trim().split('\n');
          for (final line in spaceTrimTextList) {
            texts.add(line);
          }
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
          classRoom = text.replaceAll('八草', '').replaceAll(' ', '');
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
  String selector;
  if (isCommon) {
    selector =
        '#smartPhoneCommonContactList > form:nth-child(3) > div:nth-child(1) > input';
  } else {
    selector =
        '#smartPhoneClassContactList > form:nth-child(3) > div:nth-child(1) > input';
  }
  final document = parseHtmlDocument(body);
  final topStorytitle = document.querySelectorAll(
    selector,
  );
  final value = topStorytitle[0].attributes['value'];
  return value!;
}
