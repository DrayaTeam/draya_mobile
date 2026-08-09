import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart';

class CreateClassroomUseCase implements AppUseCase<ApiResult<ClassroomModel>, CreateClassroomRequestModel> {
  final ClassroomRepo _repo;
  CreateClassroomUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomModel>> call({CreateClassroomRequestModel? params}) =>
      _repo.createClassroom(params!);
}
