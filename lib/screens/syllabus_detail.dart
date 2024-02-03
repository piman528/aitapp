// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';
import 'dart:ui';

import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/models/get_syllabus.dart';
import 'package:flutter/material.dart';

class SyllabusDetail extends StatelessWidget {
  const SyllabusDetail({
    super.key,
    required this.getSyllabus,
    required this.syllabus,
  });
  final GetSyllabus getSyllabus;
  final ClassSyllabus syllabus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(syllabus.subject),
      ),
      body: FutureBuilder(
        future: getSyllabus.getSyllabusDetail(syllabus),
        builder: (
          BuildContext context,
          AsyncSnapshot<ClassSyllabusDetail> snapshot,
        ) {
          if (snapshot.hasData) {
            final classSyllabusDetail = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(classSyllabusDetail.classRoom),
                    Text(
                      '${classificationToString[classSyllabusDetail.classification]} ${classSyllabusDetail.unitsNumber}単位    ${classSyllabusDetail.semester} ${classSyllabusDetail.classPeriod}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                for (var i = 0;
                    i < classSyllabusDetail.teacher.length;
                    i++) ...{
                  Text(
                    '${classSyllabusDetail.teacher[i]} ${classSyllabusDetail.teacherRuby[i]}',
                  ),
                },
                _buildSection('概要', classSyllabusDetail.content),
                _buildSection('計画', [classSyllabusDetail.plan.join('\n')]),
                _buildSection('学習到達目標', [classSyllabusDetail.learningGoal]),
                _buildSection('方法と特徴', [classSyllabusDetail.features]),
                _buildSection('成績評価', [classSyllabusDetail.records]),
                if (classSyllabusDetail.teachersMessage.isNotEmpty) ...{
                  _buildSection(
                    '教員メッセージ',
                    [classSyllabusDetail.teachersMessage],
                  ),
                },
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            if (snapshot.error is SocketException) {
              return const Center(
                child: Text(
                  'インターネットに接続できません',
                ),
              );
            }
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 25, //指定
                width: 25, //指定
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSection(String title, List<String> content) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        for (final text in content)
          SelectableText(text, selectionHeightStyle: BoxHeightStyle.max),
      ],
    );
  }
}
