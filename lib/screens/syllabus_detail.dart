// ignore_for_file: lines_longer_than_80_chars

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
        title: Text(syllabus.subject),
      ),
      body: FutureBuilder(
        future: getSyllabus.getSyllabusDetail(syllabus),
        builder: (
          BuildContext context,
          AsyncSnapshot<ClassSyllabusDetail> snapshot,
        ) {
          if (snapshot.hasData) {
            final syllabus = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(syllabus!.classRoom),
                        Text(
                          '${classificationToString[syllabus.classification]} ${syllabus.unitsNumber}単位    ${syllabus.semester} ${syllabus.classPeriod}',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    for (var i = 0; i <= syllabus.teacher.length; i += 3) ...{
                      Row(
                        children: [
                          Text(
                            '${syllabus.teacher[i]} ${syllabus.teacher[i + 1]}',
                          ),
                          const Spacer(),
                        ],
                      ),
                    },
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      '概要',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    for (final text in syllabus.content) ...{
                      SelectableText(
                        text,
                        selectionHeightStyle: BoxHeightStyle.max,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    },
                    const Text(
                      '計画',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SelectableText(
                      syllabus.plan.join('\n'),
                      selectionHeightStyle: BoxHeightStyle.max,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '学習到達目標',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SelectableText(
                      syllabus.learningGoal,
                      selectionHeightStyle: BoxHeightStyle.max,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '方法と特徴',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SelectableText(
                      syllabus.features,
                      selectionHeightStyle: BoxHeightStyle.max,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '成績評価',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SelectableText(
                      syllabus.records,
                      selectionHeightStyle: BoxHeightStyle.max,
                    ),
                    if (syllabus.teachersMessage != '') ...{
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '教員メッセージ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SelectableText(
                        syllabus.teachersMessage,
                        selectionHeightStyle: BoxHeightStyle.max,
                      ),
                    },
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('データが存在しません');
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
}
