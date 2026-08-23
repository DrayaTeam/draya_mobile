import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart";

class DeleteMaterialUseCase implements AppUseCase<ApiResult<void>, String> {
  final MaterialsRepo _materialsRepo;

  DeleteMaterialUseCase(this._materialsRepo);

  @override
  Future<ApiResult<void>> call({String? params}) async {
    return await _materialsRepo.deleteMaterial(materialId: params!);
  }
}
