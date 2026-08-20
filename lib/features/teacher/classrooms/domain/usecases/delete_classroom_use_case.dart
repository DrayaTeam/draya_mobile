import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class DeleteClassroomUseCase implements AppUseCase<ApiResult<void>, String> {
  final ClassroomRepo _repo;
  DeleteClassroomUseCase(this._repo);

  @override
  Future<ApiResult<void>> call({String? params}) => _repo.deleteClassroom(params!);
}
