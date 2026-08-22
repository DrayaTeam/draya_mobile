import "package:draya_mobile/core/networking/api_result.dart";

abstract class StudentFeedbackRepo {
  Future<ApiResult<void>> submitFeedback({
    required String classroomId,
    required int rating,
    required String comment,
  });
}
