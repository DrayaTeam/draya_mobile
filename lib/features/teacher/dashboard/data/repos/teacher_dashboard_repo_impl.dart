import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/pending_reviews_models.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/teacher_dashboard_model.dart";
import "package:draya_mobile/features/teacher/dashboard/data/sources/teacher_dashboard_api_service.dart";
import "package:draya_mobile/features/teacher/dashboard/domain/repos/teacher_dashboard_repo.dart";

class TeacherDashboardRepoImpl implements TeacherDashboardRepo {
  final TeacherDashboardApiService _teacherDashboardApiService;

  TeacherDashboardRepoImpl(this._teacherDashboardApiService);

  @override
  Future<ApiResult<TeacherDashboardModel>> getTeacherDashboard() async {
    try {
      final response = await _teacherDashboardApiService.getTeacherDashboard();

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<List<ClassroomPendingReviewsModel>>>
      getTeacherPendingReviews() async {
    try {
      final response =
          await _teacherDashboardApiService.getTeacherPendingReviews();

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
