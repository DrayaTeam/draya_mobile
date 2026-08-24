import "dart:io";

import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/create_reply_request_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/reply_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/repos/teacher_channel_repo.dart";

class CreateReplyParams {
  final String classroomId;
  final String questionId;
  final String content;
  final File? image;

  CreateReplyParams({
    required this.classroomId,
    required this.questionId,
    required this.content,
    this.image,
  });
}

class CreateReplyUseCase {
  final TeacherChannelRepo _repository;

  CreateReplyUseCase(this._repository);

  Future<ApiResult<ReplyModel>> call({
    required CreateReplyParams params,
  }) {
    if (params.image != null) {
      return _repository.createReplyWithPhoto(
        params.classroomId,
        params.questionId,
        params.content,
        params.image!,
      );
    }
    return _repository.createReply(
      params.classroomId,
      params.questionId,
      CreateReplyRequestModel(content: params.content),
    );
  }
}
