import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/repos/student_exam_repo.dart";

class GetGradingJobStatusUseCase
    implements AppUseCase<ApiResult<GradingJobStatus>, String> {
  final StudentExamRepo _repo;

  GetGradingJobStatusUseCase(this._repo);

  @override
  Future<ApiResult<GradingJobStatus>> call({String? params}) {
    return _repo.getGradingJobStatus(params ?? "");
  }
}
