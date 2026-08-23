import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempts_paged_result_model.dart";

abstract class StudentsGradesRepo {
  Future<ApiResult<ExamAttemptsPagedResultModel>> getExamAttempts({
    required String examId,
    required int page,
    int pageSize,
  });
}
