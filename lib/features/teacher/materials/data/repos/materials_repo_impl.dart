import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart';
import 'package:draya_mobile/features/teacher/materials/data/models/teacher_material_paged_result_model.dart';
import 'package:draya_mobile/features/teacher/materials/data/source/materials_api_service.dart';
import 'package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart';
import 'package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart';

class MaterialsRepoImpl implements MaterialsRepo {
  final MaterialsApiService _materialsApiService;

  MaterialsRepoImpl(this._materialsApiService);

  @override
  Future<ApiResult<void>> uploadMaterials({
    required String classroomId,
    required MaterialsRequestModel materialsRequestModel,
  }) async {
    try {
      final response = await _materialsApiService.uploadMaterials(
        classroomId,
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
  Future<ApiResult<TeacherMaterialPagedResultModel>> getMaterials({
    required GetMaterialsParams getMaterialsParams,
  }) async {
    try {
      final response = await _materialsApiService.getMaterials(
        getMaterialsParams.classroomId,
        getMaterialsParams.page,
        getMaterialsParams.pageSize,
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
