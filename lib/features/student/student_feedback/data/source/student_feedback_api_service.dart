import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/student_feedback/data/models/post_feedback_request_model.dart";
import "package:retrofit/retrofit.dart";

part "student_feedback_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentFeedbackApiService {
  factory StudentFeedbackApiService(Dio dio) = _StudentFeedbackApiService;

  @POST("/classrooms/{classroomId}/feedback")
  Future<void> submitFeedback({
    @Path("classroomId") required String classroomId,
    @Body() required PostFeedbackRequestModel request,
  });
}
