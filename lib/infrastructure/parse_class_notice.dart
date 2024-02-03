import 'package:aitapp/models/class_notice.dart';
import 'package:universal_html/parsing.dart';

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
      ClassNotice(
        sender,
        title,
        content,
        sendAt,
        subject,
        makeupClassAt,
        [],
        {'': ''},
      ),
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
          .replaceAll(RegExp('color: #[a-f0-9]{6};'), '');

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
  return ClassNotice(sender, title, content, sendAt, subject, '', url, fileMap);
}
