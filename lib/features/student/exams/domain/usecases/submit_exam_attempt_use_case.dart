import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/repos/student_exam_repo.dart";

class SubmitExamAttemptParams {
  final String attemptId;
  final String idempotencyKey;
  final List<GradedAnswer> answers;

  const SubmitExamAttemptParams({
    required this.attemptId,
    required this.idempotencyKey,
    required this.answers,
  });
}

class SubmitExamAttemptUseCase
    implements AppUseCase<ApiResult<String>, SubmitExamAttemptParams> {
  final StudentExamRepo _repo;

  SubmitExamAttemptUseCase(this._repo);

  @override
  Future<ApiResult<String>> call({SubmitExamAttemptParams? params}) {
    if (params == null) {
      throw ArgumentError("SubmitExamAttemptParams cannot be null");
    }
    return _repo.submitAttempt(
      attemptId: params.attemptId,
      idempotencyKey: params.idempotencyKey,
      answers: params.answers,
    );
  }
}
