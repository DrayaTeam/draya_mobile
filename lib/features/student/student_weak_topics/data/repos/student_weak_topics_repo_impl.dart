import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_weak_topics/data/source/student_weak_topics_api_service.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/ai_revision.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/practice_exam_generation.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/repos/student_weak_topics_repo.dart";

class StudentWeakTopicsRepoImpl implements StudentWeakTopicsRepo {
  final StudentWeakTopicsApiService _apiService;

  StudentWeakTopicsRepoImpl(this._apiService);

  @override
  Future<ApiResult<StudentPerformanceReport>> getLatestPerformanceReport(
    String studentId,
  ) async {
    try {
      final response = await _apiService.getLatestPerformanceReport(studentId);
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<AiRevision>> getAiRevision({
    required String studentId,
    required String topicName,
  }) async {
    try {
      final encodedTopic = Uri.encodeComponent(topicName);
      final response = await _apiService.getAiRevision(
        studentId,
        encodedTopic,
      );
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<PracticeExamGeneration>> generatePracticeExam({
    required String studentId,
    required String topicName,
  }) async {
    try {
      final encodedTopic = Uri.encodeComponent(topicName);
      final now = DateTime.now().toUtc();
      final body = {
        "startDate": now.add(const Duration(hours: 1)).toIso8601String(),
        "endDate": now.add(const Duration(days: 7)).toIso8601String(),
        // "durationMinutes": 30,
        // "allowedAttempts": 5,
        "topic": topicName,
      };
      final response = await _apiService.generatePracticeExam(
        studentId,
        encodedTopic,
        body,
      );
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
