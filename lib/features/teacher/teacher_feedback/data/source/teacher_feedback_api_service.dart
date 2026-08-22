import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/data/models/classroom_feedback_paged_result_model.dart";
import "package:retrofit/retrofit.dart";

part "teacher_feedback_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TeacherFeedbackApiService {
  factory TeacherFeedbackApiService(Dio dio) = _TeacherFeedbackApiService;

  @GET("/classrooms/{classroomId}/feedback")
  Future<ClassroomFeedbackPagedResultModel> getClassroomFeedback({
    @Path("classroomId") required String classroomId,
    @Query("page") int page = 1,
    @Query("pageSize") int pageSize = 10,
  });
}
