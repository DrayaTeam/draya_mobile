import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";

abstract class StudentExamRepo {
  Future<ApiResult<StudentExam>> getExamDetails(String examId);

  Future<ApiResult<String>> startAttempt(String examId);

  Future<ApiResult<String>> submitAttempt({
    required String attemptId,
    required String idempotencyKey,
    required List<GradedAnswer> answers,
  });

  Future<ApiResult<GradingJobStatus>> getGradingJobStatus(String jobId);

  Future<ApiResult<ExamAttemptResult>> getAttemptResults(String attemptId);
}
