class WeakTopic {
  final String topicName;
  final double proficiencyPercent;
  final String recommendation;

  const WeakTopic({
    required this.topicName,
    required this.proficiencyPercent,
    required this.recommendation,
  });
}

class SubjectProficiency {
  final String subjectName;
  final double proficiencyPercent;

  const SubjectProficiency({
    required this.subjectName,
    required this.proficiencyPercent,
  });
}

class StudentPerformanceReport {
  final String id;
  final DateTime generatedAt;
  final String summaryText;
  final List<WeakTopic> weakTopics;
  final List<SubjectProficiency> subjectProficiencies;

  const StudentPerformanceReport({
    required this.id,
    required this.generatedAt,
    required this.summaryText,
    required this.weakTopics,
    required this.subjectProficiencies,
  });
}
