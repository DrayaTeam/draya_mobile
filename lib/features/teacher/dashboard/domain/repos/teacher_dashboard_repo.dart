import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/teacher_dashboard_model.dart";

abstract interface class TeacherDashboardRepo {
  Future<ApiResult<TeacherDashboardModel>> getTeacherDashboard();
}
