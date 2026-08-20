import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/student_channel/data/models/create_question_request_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/create_reply_request_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_details_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_paged_result_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/reply_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/student_channel_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "student_channel_remote_data_source.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentChannelRemoteDataSource {
  factory StudentChannelRemoteDataSource(Dio dio) =
      _StudentChannelRemoteDataSource;

  @GET(StudentChannelApiConstants.classroomQuestions)
  Future<QuestionPagedResultModel> getQuestions(
    @Path("classroomId") String classroomId,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("sortBy") String sortBy,
    @Query("filterBy") String filterBy,
  );

  @POST(StudentChannelApiConstants.createQuestion)
  Future<QuestionModel> createQuestion(
    @Path("classroomId") String classroomId,
    @Body() CreateQuestionRequestModel request,
  );

  @GET(StudentChannelApiConstants.questionById)
  Future<QuestionDetailsModel> getQuestionDetails(
    @Path("classroomId") String classroomId,
    @Path("questionId") String questionId,
  );

  @POST(StudentChannelApiConstants.createReply)
  Future<ReplyModel> createReply(
    @Path("classroomId") String classroomId,
    @Path("questionId") String questionId,
    @Body() CreateReplyRequestModel request,
  );

  @POST(StudentChannelApiConstants.voteQuestion)
  Future<void> voteQuestion(
    @Path("classroomId") String classroomId,
    @Path("questionId") String questionId,
  );

  @DELETE(StudentChannelApiConstants.unvoteQuestion)
  Future<void> unvoteQuestion(
    @Path("classroomId") String classroomId,
    @Path("questionId") String questionId,
  );
}
