import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/pending_reviews_models.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/teacher_dashboard_model.dart";
import "package:draya_mobile/features/teacher/dashboard/data/sources/teacher_dashboard_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "teacher_dashboard_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TeacherDashboardApiService {
  factory TeacherDashboardApiService(Dio dio) = _TeacherDashboardApiService;

  @GET(TeacherDashboardApiConstants.teacherDashboard)
  Future<TeacherDashboardModel> getTeacherDashboard();

  @GET(TeacherDashboardApiConstants.teacherPendingReviews)
  Future<List<ClassroomPendingReviewsModel>> getTeacherPendingReviews();
}
