import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/update_classroom_request_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart';

class UpdateClassroomParams {
  final String classroomId;
  final UpdateClassroomRequestModel request;
  const UpdateClassroomParams({required this.classroomId, required this.request});
}

class UpdateClassroomUseCase implements AppUseCase<ApiResult<ClassroomModel>, UpdateClassroomParams> {
  final ClassroomRepo _repo;
  UpdateClassroomUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomModel>> call({UpdateClassroomParams? params}) =>
      _repo.updateClassroom(params!.classroomId, params.request);
}
