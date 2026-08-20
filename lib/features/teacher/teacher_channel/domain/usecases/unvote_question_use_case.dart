import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/repos/teacher_channel_repo.dart";

class UnvoteQuestionParams {
  final String classroomId;
  final String questionId;

  UnvoteQuestionParams({
    required this.classroomId,
    required this.questionId,
  });
}

class UnvoteQuestionUseCase {
  final TeacherChannelRepo _repository;

  UnvoteQuestionUseCase(this._repository);

  Future<ApiResult<void>> call({
    required UnvoteQuestionParams params,
  }) => _repository.unvoteQuestion(params.classroomId, params.questionId);
}
