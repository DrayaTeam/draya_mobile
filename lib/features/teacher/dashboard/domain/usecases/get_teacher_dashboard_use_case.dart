import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/teacher_dashboard_model.dart";
import "package:draya_mobile/features/teacher/dashboard/domain/repos/teacher_dashboard_repo.dart";

class GetTeacherDashboardUseCase
    implements AppUseCase<ApiResult<TeacherDashboardModel>, void> {
  final TeacherDashboardRepo _teacherDashboardRepo;

  GetTeacherDashboardUseCase(this._teacherDashboardRepo);
  @override
  Future<ApiResult<TeacherDashboardModel>> call({void params}) async {
    return await _teacherDashboardRepo.getTeacherDashboard();
  }
}
