import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:draya_mobile/features/student/home/domain/repos/student_home_repo.dart";

class GetStudentDashboardUseCase
    implements AppUseCase<ApiResult<StudentDashboard>, void> {
  final StudentHomeRepo _studentHomeRepo;

  GetStudentDashboardUseCase(this._studentHomeRepo);

  @override
  Future<ApiResult<StudentDashboard>> call({void params}) async {
    return await _studentHomeRepo.getStudentDashboard();
  }
}
