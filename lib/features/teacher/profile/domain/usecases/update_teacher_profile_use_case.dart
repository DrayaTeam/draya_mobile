import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/profile/data/models/update_teacher_request_model.dart";
import "package:draya_mobile/features/teacher/profile/domain/repos/teacher_profile_repo.dart";

class UpdateTeacherProfileUseCase
    implements AppUseCase<ApiResult<void>, UpdateTeacherRequestModel> {
  final TeacherProfileRepo _teacherProfileRepo;

  UpdateTeacherProfileUseCase(this._teacherProfileRepo);

  @override
  Future<ApiResult<void>> call({UpdateTeacherRequestModel? params}) async {
    return await _teacherProfileRepo.updateTeacherProfile(
      updateTeacherRequestModel: params!,
    );
  }
}
