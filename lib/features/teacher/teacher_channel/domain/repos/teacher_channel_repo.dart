import "dart:io";

import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/create_question_request_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/create_reply_request_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_details_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_paged_result_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/reply_model.dart";

abstract class TeacherChannelRepo {
  Future<ApiResult<QuestionPagedResultModel>> getQuestions(
    String classroomId, {
    int page = 1,
    int pageSize = 20,
    String sortBy = "recent",
    String filterBy = "all",
  });

  Future<ApiResult<QuestionModel>> createQuestion(
    String classroomId,
    CreateQuestionRequestModel request,
  );

  Future<ApiResult<QuestionModel>> createQuestionWithPhoto(
    String classroomId,
    String content,
    File image,
  );

  Future<ApiResult<QuestionDetailsModel>> getQuestionDetails(
    String classroomId,
    String questionId,
  );

  Future<ApiResult<ReplyModel>> createReply(
    String classroomId,
    String questionId,
    CreateReplyRequestModel request,
  );

  Future<ApiResult<ReplyModel>> createReplyWithPhoto(
    String classroomId,
    String questionId,
    String content,
    File image,
  );

  Future<ApiResult<void>> voteQuestion(
    String classroomId,
    String questionId,
  );

  Future<ApiResult<void>> unvoteQuestion(
    String classroomId,
    String questionId,
  );
}
