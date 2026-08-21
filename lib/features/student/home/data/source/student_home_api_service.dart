import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/home/data/models/student_dashboard_model.dart";
import "package:draya_mobile/features/student/home/data/source/student_home_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "student_home_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentHomeApiService {
  factory StudentHomeApiService(Dio dio) = _StudentHomeApiService;

  @GET(StudentHomeApiConstants.studentDashboard)
  Future<StudentDashboardModel> getStudentDashboard();
}
