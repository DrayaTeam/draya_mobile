import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/repos/student_exam_repo.dart";

class GetAttemptResultsUseCase
    implements AppUseCase<ApiResult<ExamAttemptResult>, String> {
  final StudentExamRepo _repo;

  GetAttemptResultsUseCase(this._repo);

  @override
  Future<ApiResult<ExamAttemptResult>> call({String? params}) {
    return _repo.getAttemptResults(params ?? "");
  }
}
