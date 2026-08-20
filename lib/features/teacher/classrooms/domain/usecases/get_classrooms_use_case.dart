import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_paged_result_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class GetClassroomsUseCase implements AppUseCase<ApiResult<ClassroomPagedResultModel>, void> {
  final ClassroomRepo _repo;
  GetClassroomsUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomPagedResultModel>> call({void params}) => _repo.getClassrooms();
}
