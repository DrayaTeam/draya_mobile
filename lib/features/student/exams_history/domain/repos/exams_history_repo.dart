import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";

abstract class ExamsHistoryRepo {
  Future<ApiResult<StudentExamsHistoryPage>> getStudentExams({
    required int page,
    int pageSize,
  });
}
