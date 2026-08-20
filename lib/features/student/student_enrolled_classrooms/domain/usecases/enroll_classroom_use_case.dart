import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/repos/student_enrolled_classrooms_repo.dart";

class EnrollClassroomUseCase implements AppUseCase<ApiResult<void>, String> {
  final StudentEnrolledClassroomsRepo _repo;

  EnrollClassroomUseCase(this._repo);

  @override
  Future<ApiResult<void>> call({String? params}) async {
    final enrollmentCode = (params ?? "").trim();
    return _repo.enrollClassroom(enrollmentCode);
  }
}
