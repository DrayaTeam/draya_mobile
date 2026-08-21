import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";

abstract interface class StudentHomeRepo {
  Future<ApiResult<StudentDashboard>> getStudentDashboard();
}
