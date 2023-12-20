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
    this.subject,
    this.url,
  );
  final int unitsNumber;
  // 区分
  final Classification classification;
  // 教員名
  final String teacher;
  // 教科
  final String subject;
  // URL
  final String url;
}

class ClassSyllabusDetail {
  ClassSyllabusDetail(
    this.unitsNumber,
    this.classification,
    this.teacher,
    this.semester,
    this.content,
    this.subject,
    this.classPeriod,
    this.classRoom,
    this.plan,
    this.learningGoal,
    this.features,
    this.records,
    this.teachersMessage,
  );
  final int unitsNumber;
  // 区分
  final Classification classification;
  // 教員名
  final List<String> teacher;
  //開講時期
  final String semester;
  // 内容
  final List<String> content;
  // 教科
  final String subject;
  //教室
  final String classRoom;
  //曜日時限
  final String classPeriod;
  //計画
  final List<String> plan;
  //学習到達目標
  final String learningGoal;
  //方法と特徴
  final String features;
  //成績評価
  final String records;
  //教員メッセージ
  final String teachersMessage;
}
