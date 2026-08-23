import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";

abstract class MaterialsRepo {
  Future<ApiResult<void>> uploadMaterials({
    required String sectionId,
    required MaterialsRequestModel materialsRequestModel,
  });

  Future<ApiResult<SectionModel>> getMaterials({
    required GetMaterialsParams getMaterialsParams,
  });

  Future<ApiResult<void>> deleteMaterial({required String materialId});
}
