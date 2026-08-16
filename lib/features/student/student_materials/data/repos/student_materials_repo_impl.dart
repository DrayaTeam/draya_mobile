import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_materials/data/models/material_stream_model.dart';
import 'package:draya_mobile/features/student/student_materials/data/models/student_material_model.dart';
import 'package:draya_mobile/features/student/student_materials/data/models/student_material_paged_result_model.dart';
import 'package:draya_mobile/features/student/student_materials/data/source/student_materials_api_service.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/material_stream.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:draya_mobile/features/student/student_materials/domain/repos/student_materials_repo.dart';

class StudentMaterialsRepoImpl implements StudentMaterialsRepo {
  final StudentMaterialsApiService _apiService;

  StudentMaterialsRepoImpl(this._apiService);

  @override
  Future<ApiResult<StudentMaterialsPage>> getEnrolledMaterials({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.getEnrolledMaterials(
        page: page,
        pageSize: pageSize,
      );
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<StudentMaterialsPage>> getClassroomMaterials(
    String classroomId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.getClassroomMaterials(
        classroomId,
        page: page,
        pageSize: pageSize,
      );
      return ApiResult.success(
        StudentMaterialsPage(
          items: response.map((material) => material.toEntity()).toList(),
          pageNumber: page,
          pageSize: pageSize,
          totalCount: response.length,
          totalPages: response.length < pageSize ? page : page + 1,
          hasPreviousPage: page > 1,
          hasNextPage: response.length == pageSize,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<MaterialStream>> getMaterialStream(String materialId) async {
    try {
      final response = await _apiService.getMaterialStream(materialId);
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
