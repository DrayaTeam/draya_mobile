import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart";
import "package:draya_mobile/features/student/student_materials/domain/repos/student_materials_repo.dart";

class GetEnrolledMaterialsParams {
  final int page;
  final int pageSize;
  final String? classroomId;

  const GetEnrolledMaterialsParams({
    this.page = 1,
    this.pageSize = 20,
    this.classroomId,
  });
}

class GetEnrolledMaterialsUseCase
    implements AppUseCase<ApiResult<StudentMaterialsPage>, GetEnrolledMaterialsParams> {
  final StudentMaterialsRepo _repo;

  GetEnrolledMaterialsUseCase(this._repo);

  @override
  Future<ApiResult<StudentMaterialsPage>> call({
    GetEnrolledMaterialsParams? params,
  }) {
    final request = params ?? const GetEnrolledMaterialsParams();
    if (request.classroomId != null) {
      return _repo.getClassroomMaterials(
        request.classroomId!,
        page: request.page,
        pageSize: request.pageSize,
      );
    }
    return _repo.getEnrolledMaterials(page: request.page, pageSize: request.pageSize);
  }
}
