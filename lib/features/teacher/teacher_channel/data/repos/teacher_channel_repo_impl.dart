import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/create_question_request_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/create_reply_request_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/question_details_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/question_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/question_paged_result_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/models/reply_model.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/data/source/teacher_channel_remote_data_source.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/domain/repos/teacher_channel_repo.dart';

class TeacherChannelRepoImpl implements TeacherChannelRepo {
  final TeacherChannelRemoteDataSource _remoteDataSource;

  TeacherChannelRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<QuestionPagedResultModel>> getQuestions(
    String classroomId, {
    int page = 1,
    int pageSize = 20,
    String sortBy = 'recent',
    String filterBy = 'all',
  }) => _guard(
    () => _remoteDataSource.getQuestions(
      classroomId,
      page,
      pageSize,
      sortBy,
      filterBy,
    ),
  );

  @override
  Future<ApiResult<QuestionModel>> createQuestion(
    String classroomId,
    CreateQuestionRequestModel request,
  ) => _guard(() => _remoteDataSource.createQuestion(classroomId, request));

  @override
  Future<ApiResult<QuestionDetailsModel>> getQuestionDetails(
    String classroomId,
    String questionId,
  ) => _guard(
    () => _remoteDataSource.getQuestionDetails(classroomId, questionId),
  );

  @override
  Future<ApiResult<ReplyModel>> createReply(
    String classroomId,
    String questionId,
    CreateReplyRequestModel request,
  ) => _guard(
    () => _remoteDataSource.createReply(classroomId, questionId, request),
  );

  @override
  Future<ApiResult<void>> voteQuestion(
    String classroomId,
    String questionId,
  ) => _guard(() => _remoteDataSource.voteQuestion(classroomId, questionId));

  @override
  Future<ApiResult<void>> unvoteQuestion(
    String classroomId,
    String questionId,
  ) => _guard(() => _remoteDataSource.unvoteQuestion(classroomId, questionId));

  Future<ApiResult<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return ApiResult.success(await request());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
