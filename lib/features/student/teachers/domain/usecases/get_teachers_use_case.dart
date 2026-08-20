import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_model.dart";
import "package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart";

class GetTeachersUseCase implements AppUseCase<ApiResult<List<TeacherModel>>, void> {
  final TeacherRepo _teacherRepo;

  GetTeachersUseCase(this._teacherRepo);

  @override
  Future<ApiResult<List<TeacherModel>>> call({void params}) async {
    return await _teacherRepo.getTeachers();
  }
}
