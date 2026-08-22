import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/data/models/classroom_feedback_paged_result_model.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/data/source/teacher_feedback_api_service.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/domain/repos/teacher_feedback_repo.dart";

class TeacherFeedbackRepoImpl implements TeacherFeedbackRepo {
  final TeacherFeedbackApiService _apiService;

  TeacherFeedbackRepoImpl(this._apiService);

  @override
  Future<ApiResult<ClassroomFeedbackPagedResultModel>> getClassroomFeedback({
    required String classroomId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiService.getClassroomFeedback(
        classroomId: classroomId,
        page: page,
        pageSize: pageSize,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
