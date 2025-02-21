import 'dart:convert';

import 'package:aitapp/domain/types/moodle_assignment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const moodleOrigin = 'cms.aitech.ac.jp';
const webserviceEndpoint = '/webservice/rest/server.php';

class MoodleApiClient {
  static const _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  /// トークンを取得する
  Future<String> getToken({
    required String username,
    required String password,
  }) async {
    print('getMoodleToken');
    final url = Uri.parse(
      'https://$moodleOrigin/login/token.php',
    );

    final response = await http.post(
      url,
      headers: _baseHeaders,
      body: {
        'username': username,
        'password': password,
        'service': 'moodle_mobile_app',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('トークンの取得に失敗しました: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception('トークンの取得に失敗しました: ${data['error']}');
    }

    return data['token'] as String;
  }

  /// 課題一覧を取得する
  Future<List<MoodleAssignment>> getAssignments({
    required String token,
  }) async {
    print('getMoodleAssignments');
    try {
      // 課題一覧を取得
      final url = Uri.parse('https://$moodleOrigin$webserviceEndpoint');
      final response = await http.post(
        url,
        headers: _baseHeaders,
        body: {
          'wstoken': token,
          'wsfunction': 'mod_assign_get_assignments',
          'moodlewsrestformat': 'json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('課題一覧の取得に失敗しました: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('exception')) {
        throw Exception('課題一覧の取得に失敗しました: ${data['message']}');
      }

      final courses = data['courses'] as List<dynamic>;
      final assignments = <MoodleAssignment>[];

      for (final course in courses) {
        final courseId = course['id'] as int;
        final courseName = course['fullname'] as String;
        final assignmentsList = course['assignments'] as List<dynamic>;

        for (final assignment in assignmentsList) {
          assignments.add(
            MoodleAssignment(
              id: assignment['id'] as int,
              name: assignment['name'] as String,
              description: assignment['intro'] as String,
              dueDate: DateTime.fromMillisecondsSinceEpoch(
                (assignment['duedate'] as int) * 1000,
              ),
              courseId: courseId,
              courseName: courseName,
            ),
          );
        }
      }

      return assignments;
    } catch (e) {
      debugPrint('Error getting assignments: $e');
      rethrow;
    }
  }
}
