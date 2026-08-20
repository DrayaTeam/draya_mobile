import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/data/models/teacher_material_paged_result_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart";

class GetMaterialsParams {
  final String classroomId;
  final int page;
  final int pageSize;

  const GetMaterialsParams({
    required this.classroomId,
    this.page = 1,
    this.pageSize = 20,
  });
}

class GetMaterialsUseCase
    implements
        AppUseCase<
          ApiResult<TeacherMaterialPagedResultModel>,
          GetMaterialsParams
        > {
  final MaterialsRepo _materialsRepo;

  GetMaterialsUseCase(this._materialsRepo);

  @override
  Future<ApiResult<TeacherMaterialPagedResultModel>> call({
    GetMaterialsParams? params,
  }) async {
    return await _materialsRepo.getMaterials(getMaterialsParams: params!);
  }
}
