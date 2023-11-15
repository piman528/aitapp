import 'package:aitapp/tab/notice_list.dart';
import 'package:flutter/material.dart';
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
        for (final line in spaceTrimTextList) {
          texts.add(line);
        }
      }
    }
    var c = 0;
    var sender = '';
    var title = '';
    const content = '';
    const sendAt = '';
    var subject = '';
    var makeupClassAt = '';
    for (final text in texts) {
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
      c++;
    }
    classNoticeList.add(
      ClassNotice(sender, title, content, sendAt, subject, makeupClassAt),
    );
  }
  return classNoticeList;
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
      } else {
        final senderParse = noticeParse!.querySelectorAll('> div > div');
        for (final element2 in senderParse) {
          final spaceTrimTextList =
              element2.text!.replaceAll('	', '').trim().split('\n');
          for (final line in spaceTrimTextList) {
            if (line != '') {
              texts.add(line);
            }
          }
        }
        break;
      }
    }
    var c = 0;
    var sender = '';
    var title = '';
    const content = '';
    var sendAt = '';
    // var subject = '';
    // var makeupClassAt = '';
    for (final text in texts) {
      debugPrint('$text $c');
      switch (c) {
        case 0: // タイトル
          title = text;
        case 1: // 送信者
          sender = text;
        case 2: // 日付
          sendAt = text;
        // case 3: // 授業時間割
        //   break;
        // case 4: // 「タイトル」
        //   break;
        // case 5: // コロン
        //   break;
        // case 6: // タイトル
        //   title = text;
        // case 7: // 講師名
        //   sender = text;
        // case 8: // 「補講日」
        //   break;
        // case 9: // コロン
        //   break;
        // case 10: // 補講日日付
        //   makeupClassAt = text;
      }
      c++;
    }
    univNoticeList.add(UnivNotice(sender, title, content, sendAt));
  }
  return univNoticeList;
}
