import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart";

class UploadMaterialsParams {
  final String sectionId;
  final MaterialsRequestModel materialsRequestModel;
  const UploadMaterialsParams({
    required this.sectionId,
    required this.materialsRequestModel,
  });
}

class UploadMaterialsUseCase
    implements AppUseCase<ApiResult<void>, UploadMaterialsParams> {
  final MaterialsRepo _materialsRepo;

  UploadMaterialsUseCase(this._materialsRepo);

  @override
  Future<ApiResult<void>> call({UploadMaterialsParams? params}) async {
    return await _materialsRepo.uploadMaterials(
      sectionId: params!.sectionId,
      materialsRequestModel: params.materialsRequestModel,
    );
  }
}
