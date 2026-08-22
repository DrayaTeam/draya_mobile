import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_feedback/domain/repos/student_feedback_repo.dart";

class SubmitFeedbackUseCase
    implements AppUseCase<ApiResult<void>, SubmitFeedbackParams> {
  final StudentFeedbackRepo _repo;

  SubmitFeedbackUseCase(this._repo);

  @override
  Future<ApiResult<void>> call({SubmitFeedbackParams? params}) {
    return _repo.submitFeedback(
      classroomId: params!.classroomId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class SubmitFeedbackParams {
  final String classroomId;
  final int rating;
  final String comment;

  const SubmitFeedbackParams({
    required this.classroomId,
    required this.rating,
    required this.comment,
  });
}
