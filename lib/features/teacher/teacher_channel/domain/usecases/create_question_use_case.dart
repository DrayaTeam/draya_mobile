import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/create_question_request_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/repos/teacher_channel_repo.dart";

class CreateQuestionParams {
  final String classroomId;
  final String content;

  CreateQuestionParams({
    required this.classroomId,
    required this.content,
  });
}

class CreateQuestionUseCase {
  final TeacherChannelRepo _repository;

  CreateQuestionUseCase(this._repository);

  Future<ApiResult<QuestionModel>> call({
    required CreateQuestionParams params,
  }) => _repository.createQuestion(
    params.classroomId,
    CreateQuestionRequestModel(content: params.content),
  );
}
