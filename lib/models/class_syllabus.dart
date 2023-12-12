enum Classification {
  required,
  choice,
  requiredElective,
}

const Map<Classification, String> classificationToString = {
  Classification.required: '必修',
  Classification.choice: '選択',
  Classification.requiredElective: '選必',
};

class ClassSyllabus {
  ClassSyllabus(
    this.unitsNumber,
    this.classification,
    this.teacher,
    this.content,
    this.subject,
  );
  final int unitsNumber;
  // 区分
  final Classification classification;
  // 教員名
  final String teacher;
  // 内容
  final List<String> content;
  // 教科
  final String subject;
}
