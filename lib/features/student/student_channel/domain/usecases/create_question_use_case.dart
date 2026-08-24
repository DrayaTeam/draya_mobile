import "dart:io";

import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_channel/data/models/create_question_request_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_model.dart";
import "package:draya_mobile/features/student/student_channel/domain/repos/student_channel_repo.dart";

class CreateQuestionParams {
  final String classroomId;
  final String content;
  final File? image;

  CreateQuestionParams({
    required this.classroomId,
    required this.content,
    this.image,
  });
}

class CreateQuestionUseCase {
  final StudentChannelRepo _repository;

  CreateQuestionUseCase(this._repository);

  Future<ApiResult<QuestionModel>> call({
    required CreateQuestionParams params,
  }) {
    if (params.image != null) {
      return _repository.createQuestionWithPhoto(
        params.classroomId,
        params.content,
        params.image!,
      );
    }
    return _repository.createQuestion(
      params.classroomId,
      CreateQuestionRequestModel(content: params.content),
    );
  }
}
