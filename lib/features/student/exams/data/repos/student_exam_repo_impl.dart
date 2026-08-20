import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/data/models/attempt_models.dart";
import "package:draya_mobile/features/student/exams/data/source/student_exam_api_service.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/repos/student_exam_repo.dart";

class StudentExamRepoImpl implements StudentExamRepo {
  final StudentExamApiService _apiService;

  StudentExamRepoImpl(this._apiService);

  @override
  Future<ApiResult<StudentExam>> getExamDetails(String examId) async {
    try {
      final response = await _apiService.getExamDetails(examId);
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> startAttempt(String examId) async {
    try {
      final response = await _apiService.startAttempt(
        StartAttemptRequestModel(examId: examId),
      );
      return ApiResult.success(response.attemptId);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> submitAttempt({
    required String attemptId,
    required String idempotencyKey,
    required List<GradedAnswer> answers,
  }) async {
    try {
      final answerModels = answers.map((a) {
        return SubmitAnswerRequestModel(
          examQuestionId: a.examQuestionId,
          answerText: a.answerText ?? "",
          selectedOptionId: a.selectedOptionId,
        );
      }).toList();

      final request = SubmitAttemptRequestModel(
        idempotencyKey: idempotencyKey,
        answers: answerModels,
      );

      final response = await _apiService.submitAttempt(attemptId, request);
      return ApiResult.success(response.gradingJobId);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<GradingJobStatus>> getGradingJobStatus(String jobId) async {
    try {
      final response = await _apiService.getGradingJobStatus(jobId);
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<ExamAttemptResult>> getAttemptResults(
    String attemptId,
  ) async {
    try {
      final response = await _apiService.getAttemptResults(attemptId);
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
