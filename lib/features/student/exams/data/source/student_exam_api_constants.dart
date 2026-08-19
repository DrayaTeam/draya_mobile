abstract final class StudentExamApiConstants {
  static const String examDetails = 'students/exams/{examId}';
  static const String startAttempt = 'attempts/start';
  static const String submitAttempt = 'attempts/{attemptId}/submit';
  static const String gradingJobStatus = 'attempts/jobs/{jobId}';
  static const String attemptResults = 'attempts/{attemptId}/results';

  static const String examId = 'examId';
  static const String attemptId = 'attemptId';
  static const String jobId = 'jobId';
}
