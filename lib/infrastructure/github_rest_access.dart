import 'dart:convert';

import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:flutter/material.dart';

Future<String> getLatestVersion() async {
  debugPrint('getLatestVersion');
  final url =
      Uri.parse('https://api.github.com/repos/piman528/aitapp/releases/latest');

  final res = await httpAccess(url, headers: constHeader);
  final version = (jsonDecode(res.body) as Map)['tag_name'] as String;
  return version;
}
