import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/home/data/source/student_home_api_service.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:draya_mobile/features/student/home/domain/repos/student_home_repo.dart";

class StudentHomeRepoImpl implements StudentHomeRepo {
  final StudentHomeApiService _apiService;

  StudentHomeRepoImpl(this._apiService);

  @override
  Future<ApiResult<StudentDashboard>> getStudentDashboard() async {
    try {
      final response = await _apiService.getStudentDashboard();
      return ApiResult.success(response.toEntity());
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
