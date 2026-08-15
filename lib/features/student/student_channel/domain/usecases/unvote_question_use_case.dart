import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_channel/domain/repos/student_channel_repo.dart';

class UnvoteQuestionParams {
  final String classroomId;
  final String questionId;

  UnvoteQuestionParams({
    required this.classroomId,
    required this.questionId,
  });
}

class UnvoteQuestionUseCase {
  final StudentChannelRepo _repository;

  UnvoteQuestionUseCase(this._repository);

  Future<ApiResult<void>> call({
    required UnvoteQuestionParams params,
  }) =>
      _repository.unvoteQuestion(params.classroomId, params.questionId);
}
