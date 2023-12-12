import 'package:aitapp/models/class_syllabus.dart';
import 'package:aitapp/screens/syllabus_detail.dart';
import 'package:flutter/material.dart';

class SyllabusItem extends StatelessWidget {
  const SyllabusItem({super.key, required this.syllabus});
  final ClassSyllabus syllabus;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (ctx) => const SyllabusDetail(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  syllabus.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(syllabus.teacher),
                    const SizedBox(
                      width: 100,
                    ),
                    Text(
                      classificationToString[syllabus.classification]!,
                    ),
                    Text('${syllabus.unitsNumber} 単位'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Theme.of(context).hoverColor,
        ),
      ],
    );
  }
}
