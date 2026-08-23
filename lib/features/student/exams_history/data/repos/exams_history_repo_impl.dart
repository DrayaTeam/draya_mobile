import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams_history/data/source/exams_history_api_service.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:draya_mobile/features/student/exams_history/domain/repos/exams_history_repo.dart";

class ExamsHistoryRepoImpl implements ExamsHistoryRepo {
  final ExamsHistoryApiService _apiService;

  ExamsHistoryRepoImpl(this._apiService);

  @override
  Future<ApiResult<StudentExamsHistoryPage>> getStudentExams({
    required int page,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.getStudentExams(
        page: page,
        pageSize: pageSize,
      );
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
