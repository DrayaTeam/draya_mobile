import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_type_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class GetClassroomTypesUseCase
    implements AppUseCase<ApiResult<List<ClassroomTypeModel>>, void> {
  final ClassroomRepo _classroomRepo;

  GetClassroomTypesUseCase(this._classroomRepo);
  @override
  Future<ApiResult<List<ClassroomTypeModel>>> call({void params}) async {
    return await _classroomRepo.getClassroomTypes();
  }
}
