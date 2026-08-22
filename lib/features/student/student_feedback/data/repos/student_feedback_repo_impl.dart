import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_feedback/data/models/post_feedback_request_model.dart";
import "package:draya_mobile/features/student/student_feedback/data/source/student_feedback_api_service.dart";
import "package:draya_mobile/features/student/student_feedback/domain/repos/student_feedback_repo.dart";

class StudentFeedbackRepoImpl implements StudentFeedbackRepo {
  final StudentFeedbackApiService _apiService;

  StudentFeedbackRepoImpl(this._apiService);

  @override
  Future<ApiResult<void>> submitFeedback({
    required String classroomId,
    required int rating,
    required String comment,
  }) async {
    try {
      await _apiService.submitFeedback(
        classroomId: classroomId,
        request: PostFeedbackRequestModel(
          rating: rating,
          comment: comment.trim(),
        ),
      );
      return const ApiResult<void>.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
