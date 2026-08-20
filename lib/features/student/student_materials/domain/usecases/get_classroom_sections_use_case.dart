import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:draya_mobile/features/student/student_materials/domain/repos/student_materials_repo.dart";

class GetClassroomSectionsUseCase
    implements AppUseCase<ApiResult<List<ClassroomSection>>, String> {
  final StudentMaterialsRepo _repo;

  GetClassroomSectionsUseCase(this._repo);

  @override
  Future<ApiResult<List<ClassroomSection>>> call({String? params}) {
    if (params == null || params.isEmpty) {
      return Future.value(
        const ApiResult.success([]),
      );
    }
    return _repo.getClassroomSections(params);
  }
}
