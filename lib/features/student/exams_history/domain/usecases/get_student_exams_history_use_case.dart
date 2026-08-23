import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:draya_mobile/features/student/exams_history/domain/repos/exams_history_repo.dart";
import "package:draya_mobile/features/student/exams_history/domain/usecases/get_student_exams_history_params.dart";

class GetStudentExamsHistoryUseCase {
  final ExamsHistoryRepo _repo;

  GetStudentExamsHistoryUseCase(this._repo);

  Future<ApiResult<StudentExamsHistoryPage>> call({
    GetStudentExamsHistoryParams params =
        const GetStudentExamsHistoryParams(page: 1),
  }) {
    return _repo.getStudentExams(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
