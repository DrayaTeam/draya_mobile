import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart';

class GetClassroomByIdUseCase implements AppUseCase<ApiResult<ClassroomModel>, String> {
  final ClassroomRepo _repo;
  GetClassroomByIdUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomModel>> call({String? params}) => _repo.getClassroomById(params!);
}
