import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart";
import "package:draya_mobile/features/teacher/profile/domain/repos/teacher_profile_repo.dart";

class GetTeacherProfileUseCase
    implements AppUseCase<ApiResult<TeacherModel>, void> {
  final TeacherProfileRepo _teacherProfileRepo;

  GetTeacherProfileUseCase(this._teacherProfileRepo);

  @override
  Future<ApiResult<TeacherModel>> call({void params}) async {
    return await _teacherProfileRepo.getTeacherProfile();
  }
}
