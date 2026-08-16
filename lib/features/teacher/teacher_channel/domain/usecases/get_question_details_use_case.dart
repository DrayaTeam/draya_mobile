import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/question_details_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/domain/repos/teacher_channel_repo.dart';

class GetQuestionDetailsParams {
  final String classroomId;
  final String questionId;

  GetQuestionDetailsParams({
    required this.classroomId,
    required this.questionId,
  });
}

class GetQuestionDetailsUseCase {
  final TeacherChannelRepo _repository;

  GetQuestionDetailsUseCase(this._repository);

  Future<ApiResult<QuestionDetailsModel>> call({
    required GetQuestionDetailsParams params,
  }) => _repository.getQuestionDetails(params.classroomId, params.questionId);
}
