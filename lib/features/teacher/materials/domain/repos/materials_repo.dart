import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart';

abstract class MaterialsRepo {
  Future<ApiResult<void>> uploadMaterials({
    required String classroomId,
    required MaterialsRequestModel materialsRequestModel,
  });
}
