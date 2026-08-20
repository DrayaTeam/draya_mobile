import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";

class GetMaterialsParams {
  final String classroomId;
  final String sectionId;

  const GetMaterialsParams({
    required this.classroomId,
    required this.sectionId,
  });
}

class GetMaterialsUseCase
    implements AppUseCase<ApiResult<SectionModel>, GetMaterialsParams> {
  final MaterialsRepo _materialsRepo;

  GetMaterialsUseCase(this._materialsRepo);

  @override
  Future<ApiResult<SectionModel>> call({
    GetMaterialsParams? params,
  }) async {
    return await _materialsRepo.getMaterials(getMaterialsParams: params!);
  }
}
