import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_channel/domain/repos/student_channel_repo.dart";

class VoteQuestionParams {
  final String classroomId;
  final String questionId;

  VoteQuestionParams({
    required this.classroomId,
    required this.questionId,
  });
}

class VoteQuestionUseCase {
  final StudentChannelRepo _repository;

  VoteQuestionUseCase(this._repository);

  Future<ApiResult<void>> call({
    required VoteQuestionParams params,
  }) =>
      _repository.voteQuestion(params.classroomId, params.questionId);
}
