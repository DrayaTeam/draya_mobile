import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/data/models/classroom_feedback_paged_result_model.dart";

abstract class TeacherFeedbackRepo {
  Future<ApiResult<ClassroomFeedbackPagedResultModel>> getClassroomFeedback({
    required String classroomId,
    int page = 1,
    int pageSize = 10,
  });
}
