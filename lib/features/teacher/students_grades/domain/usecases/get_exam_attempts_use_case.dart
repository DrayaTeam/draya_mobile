import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempts_paged_result_model.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/repos/students_grades_repo.dart";

class GetExamAttemptsParams {
  final String examId;
  final int page;
  final int pageSize;

  const GetExamAttemptsParams({
    required this.examId,
    required this.page,
    this.pageSize = 10,
  });
}

class GetExamAttemptsUseCase
    implements
        AppUseCase<ApiResult<ExamAttemptsPagedResultModel>,
            GetExamAttemptsParams> {
  final StudentsGradesRepo _repo;

  GetExamAttemptsUseCase(this._repo);

  @override
  Future<ApiResult<ExamAttemptsPagedResultModel>> call({
    GetExamAttemptsParams? params,
  }) {
    return _repo.getExamAttempts(
      examId: params!.examId,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
