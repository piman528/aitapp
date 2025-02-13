import 'dart:io';

import 'package:aitapp/domain/features/lcam_parse.dart';
import 'package:aitapp/domain/types/academic_year.dart';
import 'package:aitapp/domain/types/calendar_event.dart';
import 'package:aitapp/domain/types/class.dart';
import 'package:aitapp/domain/types/cookies.dart';
import 'package:aitapp/domain/types/day_of_week.dart';
import 'package:aitapp/domain/types/exception.dart';
import 'package:aitapp/domain/types/notice.dart';
import 'package:aitapp/domain/types/notice_detail.dart';
import 'package:aitapp/domain/types/semester.dart';
import 'package:aitapp/infrastructure/restaccess/access_lcan.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GetLcamData {
  late Cookies cookies;
  late String? token;
  final parse = LcamParse();

  Future<bool> create(String id, String password) async {
    token = null;
    cookies = await getCookie();
    return parse
        .isLogin(await loginLcam(id: id, password: password, cookies: cookies));
  }

  Future<List<Notice>> getNoticelist({
    required int page,
    required bool isCommon,
    required bool withLogin,
  }) async {
    if (withLogin) {
      final tempToken = parse.lCamStrutsToken(
        body: await getStrutsToken(
          cookies: cookies,
          isCommon: isCommon,
        ),
      );
      token = parse.lCamStrutsToken(
        body: await getNoticeBody(
          cookies: cookies,
          token: tempToken,
          isCommon: isCommon,
        ),
      );
    }

    final body = await getNoticeBodyNext(
      cookies: cookies,
      token: token!,
      pageNumber: page,
      isCommon: isCommon,
    );
    token = parse.lCamStrutsToken(body: body);

    if (isCommon) {
      return parse.univNotice(body);
    } else {
      return parse.classNotice(body);
    }
  }

  Future<NoticeDetail> getNoticeDetail({
    required int pageNumber,
    required bool isCommon,
  }) async {
    if (cookies.jSessionId.isEmpty) {
      throw Exception('ログインできません');
    }
    final body = await getNoticeDetailBody(
      index: pageNumber,
      cookies: cookies,
      token: token!,
      isCommon: isCommon,
    );
    if (isCommon) {
      return parse.univNoticeDetail(body);
    } else {
      return parse.classNoticeDetail(body);
    }
  }

  Future<File> shareFile(
    MapEntry<String, String> entry,
    BuildContext context,
  ) async {
    final response = await getFile(
      cookies: cookies,
      fileUrl: entry.value,
    );
    final contentType = response.headers['content-type']!;
    if (contentType != 'text/html;charset=utf-8') {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${entry.key}');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw const GetDataException('[shareFile]データの取得に失敗しました');
    }
  }

  Future<Map<DayOfWeek, Map<int, Class>>> getClassTimeTable() async {
    final body = await getClassTimeTableBody(cookies: cookies);
    return parse.classTimeTable(body);
  }
}

class GetPCLcamData {
  late Cookies cookies;
  late String? token;
  final parse = LcamParse();

  // pc版にログインする
  Future<bool> create(String id, String password) async {
    token = null;
    cookies = await pcGetCookie();
    final jsessionid = await preAccess(cookie: cookies);
    cookies = Cookies(
      jSessionId: jsessionid,
      liveAppsCookie: cookies.liveAppsCookie,
    );
    final loginResult = await initLogin(
      id: id,
      password: password,
      cookies: cookies,
    );
    token = LcamParse().lCamStrutsToken(body: loginResult);
    return true;
  }

  Future<Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>>
      getClassTimeTable() async {
    final generalPurposeResult =
        await generalPurpose(cookies: cookies, token: token!);
    final result = <int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>{};
    token = LcamParse().lCamStrutsToken(body: generalPurposeResult);
    var year = AcademicYear.getCurrent();
    var semester = Semester.getCurrent();
    // 結果用のMapを初期化
    result[year] = {
      Semester.early: {},
      Semester.late: {},
    };
    while (true) {
      debugPrint('year: $year, semester: $semester');
      final body = await searchTimeTable(
        cookies: cookies,
        token: token!,
        year: '$year',
        semester: semester == Semester.early ? '1' : '2',
      );
      final timetable = LcamParse().pcClassTimeTable(
        body,
      );
      if (timetable.entries.isEmpty) {
        break;
      }
      token = LcamParse().lCamStrutsToken(body: body);
      // 年度のMapが未初期化の場合は初期化
      result[year] ??= {};
      // 学期のMapが未初期化の場合は初期化
      result[year]?[semester] ??= {};
      // 時間割データを保存
      result[year]![semester] = timetable;
      if (semester == Semester.early) {
        year--;
        semester = Semester.late;
      } else {
        semester = Semester.early;
      }
    }

    return result;
  }

  Future<Map<DateTime, List<CalendarEvent>>> getShedule() async {
    final result = <DateTime, List<CalendarEvent>>{};
    var body = '';

    for (var i = 0; i < 10; i++) {
      body = await reload(cookie: cookies, token: token!);
      token = LcamParse().lCamStrutsToken(body: body);
      final schedules = parse.schedule(body);
      result.addAll(schedules);
      await getSchedule(cookie: cookies);
    }
    body = await reload(cookie: cookies, token: token!);
    token = LcamParse().lCamStrutsToken(body: body);
    final schedules = parse.schedule(body);
    result.addAll(schedules);

    return result;
  }
}
