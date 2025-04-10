import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/class.dart';
import 'package:aitapp/domain/types/class_notice.dart';
import 'package:aitapp/domain/types/class_notice_detail.dart';
import 'package:aitapp/domain/types/class_period.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/event.dart';
import 'package:aitapp/domain/types/exception.dart';
import 'package:aitapp/domain/types/univ_notice.dart';
import 'package:aitapp/domain/types/univ_notice_detail.dart';
import 'package:universal_html/html.dart';
import 'package:universal_html/parsing.dart';

class LcamParse {
  bool isLogin(String body) {
    final isLogin = parseHtmlDocument(body)
        .querySelectorAll('#_errorInformation > ul > li:nth-child(1)')
        .isEmpty;
    return isLogin;
  }

  List<ClassNotice> classNotice(String body) {
    final classNoticeList = <ClassNotice>[];
    final rows = parseHtmlDocument(body).querySelectorAll(
      '#smartPhoneClassContactList > form:nth-child(4) > div.listItem',
    );
    if (rows.isEmpty) {
      throw const GetDataException('[parseClassNotice]データの取得に失敗しました');
    }

    for (var i = 0; i < rows.length; i++) {
      //1通知ごと
      final texts = _extractText(rows[i]);

      var c = 0;
      var sender = '';
      var title = '';
      var makeupClassAt = '';
      var isImportant = false;
      for (final text in texts) {
        switch (c) {
          case 6: // タイトル
            if (text == '重要') {
              isImportant = true;
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
        ClassNotice(
          sender: sender,
          title: title,
          subject: texts[2],
          makeupClassAt: makeupClassAt,
          isInportant: isImportant,
          index: i,
        ),
      );
    }
    return classNoticeList;
  }

  List<String> _extractText(Element row) {
    final texts = <String>[];
    final contents =
        row.querySelector('> table > tbody > tr > td:nth-child(1)');
    for (final text in contents!.text!.replaceAll('	', '').trim().split('\n')) {
      if (text != '') {
        texts.add(text);
      }
    }
    return texts;
  }

  ClassNoticeDetail classNoticeDetail(String body) {
    final topStorytitle = parseHtmlDocument(body).querySelectorAll(
      'body > form > table > tbody > tr',
    );
    if (topStorytitle.isEmpty) {
      throw const GetDataException('[parseClassNoticeDetail]データの取得に失敗しました');
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
          }
        }
      } else if (mainContent == 1) {
        final html = tr.querySelector('td > div')!.outerHtml!;
        final filteredHtml = html
            .replaceAll(RegExp('style="background-color: #[a-f0-9]{6};"'), '')
            .replaceAll(RegExp('style="color: #[a-f0-9]{6};"'), '')
            .replaceAll(RegExp('background-color: #[a-f0-9]{6};'), '')
            .replaceAll(RegExp('color: #[a-f0-9]{6};'), '')
            .replaceAllMapped(
                RegExp(
                  r"(http(s)?:\/\/[a-zA-Z0-9-.!'*;/?:@&=+$,%_#]+)",
                  caseSensitive: false,
                ), (match) {
          final url = match.group(0)!;
          return '<a href="$url">$url</a>';
        });

        texts.add(
          '<html><body>$filteredHtml</body></html>',
        );
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
        case '内容':
          mainContent = 1;
        case 'ファイル':
          mainContent = 2;
      }
    }
    final titleindex = texts.indexOf('タイトル') + 1;
    final title =
        texts[titleindex] != '重要' ? texts[titleindex] : texts[titleindex + 1];
    final url = <String>[];
    for (var i = texts.indexOf('参考URL') + 1; i < texts.indexOf('連絡日時'); i++) {
      url.add(texts[i]);
    }
    return ClassNoticeDetail(
      sender: texts[texts.indexOf('授業科目') + 3],
      title: title,
      sendAt: texts[texts.indexOf('連絡日時') + 1],
      content: texts[texts.indexOf('内容') + 1],
      subject: texts[texts.indexOf('授業科目') + 1],
      url: url,
      files: fileMap,
    );
  }

  Map<DayOfWeek, Map<int, Class>> pcClassTimeTable(String body) {
    final classTimeTableMap = <DayOfWeek, Map<int, Class>>{};
    final topStorytitle = parseHtmlDocument(body).querySelectorAll(
      '#st1 > div > table > tbody > tr',
    );
    if (topStorytitle.isEmpty) {
      throw const GetDataException('[parseClassTimeTable]データの取得に失敗しました');
    }
    for (var i = 1; i < topStorytitle.length; i++) {
      for (var j = 1; j < topStorytitle[i].children.length; j++) {
        if (topStorytitle[i].children[j].children.isNotEmpty) {
          var subject = '';
          var teacher = '';
          var classRoom = '';
          for (var k = 0; k < 3; k++) {
            final text = topStorytitle[i]
                .children[j]
                .children[0]
                .children[k]
                .text!
                .trim();
            switch (k) {
              case 0: //授業科目
                subject = text.replaceAll('[八]', '');
              case 1: // 教員
                teacher = text.replaceAll(RegExp(r'　他$'), '').split('/').first;
              case 2: // 教室
                classRoom = text.replaceAll('八草', '').trim();
            }
          }
          final dayOfWeek = switch (j) {
            1 => DayOfWeek.monday,
            2 => DayOfWeek.tuesday,
            3 => DayOfWeek.wednesday,
            4 => DayOfWeek.thurstay,
            5 => DayOfWeek.friday,
            6 => DayOfWeek.saturday,
            _ => DayOfWeek.sunday,
          };
          if (subject != '') {
            classTimeTableMap[dayOfWeek] ??= <int, Class>{};
            classTimeTableMap[dayOfWeek]![i] =
                Class(title: subject, classRoom: classRoom, teacher: teacher);
          }
        }
      }
    }
    return classTimeTableMap;
  }

  Map<DateTime, List<CalendarEvent>> schedule(String body) {
    final result = <DateTime, List<CalendarEvent>>{};

    final element = parseHtmlDocument(body).querySelector(
      'table.calendar-body',
    );
    if (element == null) {
      throw const GetDataException('[parseClassTimeTable]データの取得に失敗しました');
    }
    final now = DateTime.now();
    final dates = element.querySelectorAll('thead > tr > th').map((e) {
      final dateText = e.innerText.trim();
      final match = RegExp(r'(\d{1,2})/(\d{1,2})').firstMatch(dateText);
      if (match == null) {
        throw const GetDataException('[parseClassTimeTable]データの取得に失敗しました');
      }
      final month = int.parse(match.group(1)!);
      final day = int.parse(match.group(2)!);
      final year = now.month > month ? now.year + 1 : now.year;
      return DateTime(year, month, day);
    }).toList();
    final contents = element.querySelectorAll('tbody > tr > td > div');

    for (var i = 0; i < dates.length; i++) {
      final eventsList = <CalendarEvent>[];
      final events =
          contents[i].innerHtml?.split('<hr class="schedule_line" noshade="">');

      if (events != null) {
        for (final event in events) {
          String? eventText;
          String? location;
          String? teacher;
          ClassPeriod? period;

          final formatedEventList = event
              .split('<br>')
              .map((e) => e.trim())
              .toList()
              .where((e) => e.isNotEmpty)
              .toList();

          if (formatedEventList.isNotEmpty) {
            if (formatedEventList.length == 4) {
              teacher = formatedEventList[2].replaceAll('他', '').trim();
              location = formatedEventList[3];
              eventText = formatedEventList[1].replaceAll('[八]', '');
              final periodMatch =
                  RegExp(r'(Ⅰ|Ⅱ|Ⅲ|Ⅳ|Ⅴ)限').firstMatch(formatedEventList[0]);
              period = switch (periodMatch?.group(1)) {
                'Ⅰ' => ClassPeriod.period1,
                'Ⅱ' => ClassPeriod.period2,
                'Ⅲ' => ClassPeriod.period3,
                'Ⅳ' => ClassPeriod.period4,
                'Ⅴ' => ClassPeriod.period5,
                _ => null,
              };
            } else if (formatedEventList.length == 1) {
              eventText = formatedEventList[0];
            }

            if (period != null && eventText != null) {
              eventsList.add(
                UnivEvent.fromPeriod(
                  title: eventText,
                  period: period,
                  location: location,
                  teacher: teacher,
                  date: dates[i],
                ),
              );
            } else if (eventText != null) {
              eventsList.add(
                CalendarEvent(
                  title: eventText,
                  startTime: dates[i],
                  endTime: dates[i].add(const Duration(hours: 23, minutes: 59)),
                ),
              );
            }
          }
        }
      }
      result[dates[i]] = eventsList;
    }

    return result;
  }

  Map<DayOfWeek, Map<int, Class>> classTimeTable(String body) {
    final classTimeTableMap = <DayOfWeek, Map<int, Class>>{};
    final topStorytitle = parseHtmlDocument(body).querySelectorAll(
      'body > form > table > tbody > tr',
    );
    if (topStorytitle.isEmpty) {
      throw const GetDataException('[parseClassTimeTable]データの取得に失敗しました');
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
            teacher = text.replaceAll(RegExp(r'　他$'), '');
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

  String lCamStrutsToken({required String body}) {
    final selectors = [
      '#header > form > div > input',
      '#smartPhoneCommonContactList > form:nth-child(3) > div:nth-child(1) > input',
      '#smartPhoneClassContactList > form:nth-child(3) > div:nth-child(1) > input',
    ];
    var topStorytitle = <Element>[];
    for (var i = 0; i < selectors.length; i++) {
      topStorytitle = parseHtmlDocument(body).querySelectorAll(
        selectors[i],
      );
      if (topStorytitle.isNotEmpty) {
        final value = topStorytitle.first.attributes['value'];
        if (value != null) {
          return value;
        }
      }
    }
    throw const GetDataException('[parseLcamStrutsToken]データの取得に失敗しました');
  }

  List<UnivNotice> univNotice(String body) {
    final univNoticeList = <UnivNotice>[]; //return
    final rows = parseHtmlDocument(body).querySelectorAll(
      '#smartPhoneCommonContactList > form:nth-child(4) > div.listItem',
    ); //記事のリスト
    if (rows.isEmpty) {
      throw const GetDataException('[parseUnivNotice]データの取得に失敗しました');
    }

    for (var i = 0; i < rows.length; i++) {
      final texts = _extractText(rows[i]);
      var c = 0;
      var sender = '';
      var title = '';
      var sendAt = '';
      var isImportant = false;
      for (final text in texts) {
        switch (c) {
          case 0: // タイトル
            if (text == '重要') {
              isImportant = true;
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
      univNoticeList.add(
        UnivNotice(
          sender: sender,
          title: title,
          sendAt: sendAt,
          isInportant: isImportant,
          index: i,
        ),
      );
    }
    return univNoticeList;
  }

  UnivNoticeDetail univNoticeDetail(String body) {
    final topStorytitle = parseHtmlDocument(body).querySelectorAll(
      'body > form > table > tbody > tr',
    );
    if (topStorytitle.isEmpty) {
      throw const GetDataException('[parseUnivNoticeDetail]データの取得に失敗しました');
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
        final html = tr.querySelector('td > div')!.outerHtml!;
        final filteredHtml = html
            .replaceAll(RegExp('style="background-color: #[a-f0-9]{6};"'), '')
            .replaceAll(RegExp('style="color: #[a-f0-9]{6};"'), '')
            .replaceAll(RegExp('background-color: #[a-f0-9]{6};'), '')
            .replaceAll(RegExp('color: #[a-f0-9]{6};'), '')
            .replaceAllMapped(
                RegExp(
                  r"(http(s)?:\/\/[a-zA-Z0-9-.!'*;/?:@&=+$,%_#]+)",
                  caseSensitive: false,
                ), (match) {
          final url = match.group(0)!;
          return '<a href="$url">$url</a>';
        });
        texts.add(
          filteredHtml,
        );
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
    final content = texts[texts.indexOf('連絡内容') + 1];
    final sendAt = texts[texts.indexOf('連絡日時') + 1];
    final url = <String>[];
    for (var i = texts.indexOf('参考URL') + 1; i < texts.indexOf('連絡日時'); i++) {
      url.add(texts[i]);
    }
    return UnivNoticeDetail(
      sender: sender,
      title: title,
      content: content,
      sendAt: sendAt,
      url: url,
      files: fileMap,
    );
  }
}
