import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/data/source/materials_api_service.dart";
import "package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/data/sources/section_api_service.dart";

class MaterialsRepoImpl implements MaterialsRepo {
  final MaterialsApiService _materialsApiService;
  final SectionApiService _sectionApiService;

  MaterialsRepoImpl(
    this._materialsApiService,
    this._sectionApiService,
  );

  @override
  Future<ApiResult<void>> uploadMaterials({
    required String sectionId,
    required MaterialsRequestModel materialsRequestModel,
  }) async {
    try {
      final response = await _materialsApiService.uploadMaterials(
        sectionId,
        materialsRequestModel.title,
        materialsRequestModel.materialType.name,
        await MultipartFile.fromFile(
          materialsRequestModel.file.path!,
          filename: materialsRequestModel.file.name,
        ),
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<SectionModel>> getMaterials({
    required GetMaterialsParams getMaterialsParams,
  }) async {
    try {
      final response = await _sectionApiService.getSections(
        getMaterialsParams.classroomId,
      );

      final section = response.firstWhere(
        (section) {
          return section.id == getMaterialsParams.sectionId;
        },
      );

      return ApiResult.success(section);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteMaterial({required String materialId}) async {
    try {
      final response = await _materialsApiService.deleteMaterial(materialId);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
