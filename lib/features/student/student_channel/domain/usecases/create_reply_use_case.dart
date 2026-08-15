import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_channel/data/models/create_reply_request_model.dart';
import 'package:draya_mobile/features/student/student_channel/data/models/reply_model.dart';
import 'package:draya_mobile/features/student/student_channel/domain/repos/student_channel_repo.dart';

class CreateReplyParams {
  final String classroomId;
  final String questionId;
  final String content;

  CreateReplyParams({
    required this.classroomId,
    required this.questionId,
    required this.content,
  });
}

class CreateReplyUseCase {
  final StudentChannelRepo _repository;

  CreateReplyUseCase(this._repository);

  Future<ApiResult<ReplyModel>> call({
    required CreateReplyParams params,
  }) =>
      _repository.createReply(
        params.classroomId,
        params.questionId,
        CreateReplyRequestModel(content: params.content),
      );
}
