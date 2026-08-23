import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/pending_reviews_models.dart";
import "package:draya_mobile/features/teacher/dashboard/domain/repos/teacher_dashboard_repo.dart";

class GetTeacherPendingReviewsUseCase
    implements
        AppUseCase<ApiResult<List<ClassroomPendingReviewsModel>>, void> {
  final TeacherDashboardRepo _teacherDashboardRepo;

  GetTeacherPendingReviewsUseCase(this._teacherDashboardRepo);

  @override
  Future<ApiResult<List<ClassroomPendingReviewsModel>>> call(
      {void params}) async {
    return await _teacherDashboardRepo.getTeacherPendingReviews();
  }
}
