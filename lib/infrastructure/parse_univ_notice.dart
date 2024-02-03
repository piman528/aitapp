import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/models/univ_notice_detail.dart';
import 'package:universal_html/parsing.dart';

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
    univNoticeList.add(
      UnivNotice(
        sender: sender,
        title: title,
        sendAt: sendAt,
      ),
    );
  }
  return univNoticeList;
}

UnivNoticeDetail parseUnivNoticeDetail(String body) {
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
