// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:aitapp/domain/features/get_syllabus.dart';
import 'package:aitapp/domain/types/class_syllabus.dart';
import 'package:aitapp/domain/types/class_syllabus_detail.dart';
import 'package:aitapp/presentation/wighets/build_section.dart';
import 'package:aitapp/presentation/wighets/loading/detail_loading.dart';
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
        title: Text(
          syllabus.subject,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getSyllabus.getSyllabusDetail(syllabus),
        builder: (
          BuildContext context,
          AsyncSnapshot<ClassSyllabusDetail> snapshot,
        ) {
          if (snapshot.hasData) {
            final classSyllabusDetail = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                classSyllabusDetail.classRoom,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${classSyllabusDetail.classification.displayName} ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${classSyllabusDetail.unitsNumber}単位',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' ${classSyllabusDetail.semester} ${classSyllabusDetail.classPeriod}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '担当教員',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final teacher
                                  in classSyllabusDetail.teachers)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        teacher.toStr(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      BuildSection(
                        title: '概要',
                        content: classSyllabusDetail.content,
                      ),
                      BuildSection(
                        title: '計画',
                        content: [classSyllabusDetail.plan.join('\n')],
                      ),
                      BuildSection(
                        title: '学習到達目標',
                        content: [classSyllabusDetail.learningGoal],
                      ),
                      BuildSection(
                        title: '方法と特徴',
                        content: [classSyllabusDetail.features],
                      ),
                      BuildSection(
                        title: '成績評価',
                        content: [classSyllabusDetail.records],
                      ),
                      if (classSyllabusDetail.teachersMessage.isNotEmpty)
                        BuildSection(
                          title: '教員メッセージ',
                          content: [classSyllabusDetail.teachersMessage],
                        ),
                      BuildSection(
                        title: '教科書',
                        content: [classSyllabusDetail.textBook],
                      ),
                      if (classSyllabusDetail.referenceBook.isNotEmpty)
                        BuildSection(
                          title: '参考書',
                          content: [classSyllabusDetail.referenceBook],
                        ),
                      const SizedBox(height: 32),
                    ]),
                  ),
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
            return const DetailLoadingWidget();
          }
        },
      ),
    );
  }
}
