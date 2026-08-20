import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_paged_result_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class GetClassroomStudentsUseCase implements AppUseCase<ApiResult<StudentRosterPagedResultModel>, String> {
  final ClassroomRepo _repo;
  GetClassroomStudentsUseCase(this._repo);

  @override
  Future<ApiResult<StudentRosterPagedResultModel>> call({String? params}) =>
      _repo.getClassroomStudents(params!);
}
