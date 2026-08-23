abstract final class StudentsGradesApiConstants {
  static const String examId = "examId";
  static const String attemptId = "attemptId";
  static const String answerId = "answerId";
  static const String examAttempts = "/exams/{$examId}/attempts";
  static const String attemptResults = "/attempts/{$attemptId}/results";
  static const String overrideAnswerScore =
      "/attempts/{$attemptId}/answers/{$answerId}/override";
}
