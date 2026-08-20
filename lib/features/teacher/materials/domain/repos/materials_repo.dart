import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/data/models/teacher_material_paged_result_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";

abstract class MaterialsRepo {
  Future<ApiResult<void>> uploadMaterials({
    required String classroomId,
    required MaterialsRequestModel materialsRequestModel,
  });

  Future<ApiResult<TeacherMaterialPagedResultModel>> getMaterials({
    required GetMaterialsParams getMaterialsParams,
  });
}
