import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/attempt_review_models.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempts_paged_result_model.dart";

abstract class StudentsGradesRepo {
  Future<ApiResult<ExamAttemptsPagedResultModel>> getExamAttempts({
    required String examId,
    required int page,
    int pageSize,
  });

  Future<ApiResult<AttemptReviewResultsModel>> getAttemptResults(
    String attemptId,
  );

  Future<ApiResult<void>> overrideAnswerScore({
    required String attemptId,
    required String answerId,
    required double newScore,
  });
}
