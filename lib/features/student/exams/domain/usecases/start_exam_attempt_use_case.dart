import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/repos/student_exam_repo.dart";

class StartExamAttemptUseCase
    implements AppUseCase<ApiResult<String>, String> {
  final StudentExamRepo _repo;

  StartExamAttemptUseCase(this._repo);

  @override
  Future<ApiResult<String>> call({String? params}) {
    return _repo.startAttempt(params ?? "");
  }
}
