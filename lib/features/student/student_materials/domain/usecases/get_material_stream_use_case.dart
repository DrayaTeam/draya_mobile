import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/material_stream.dart';
import 'package:draya_mobile/features/student/student_materials/domain/repos/student_materials_repo.dart';

class GetMaterialStreamUseCase
    implements AppUseCase<ApiResult<MaterialStream>, String> {
  final StudentMaterialsRepo _repo;

  GetMaterialStreamUseCase(this._repo);

  @override
  Future<ApiResult<MaterialStream>> call({String? params}) {
    return _repo.getMaterialStream(params!);
  }
}
