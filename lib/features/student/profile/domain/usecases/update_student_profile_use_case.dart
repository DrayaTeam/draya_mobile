import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/profile/data/models/student_profile_model.dart";
import "package:draya_mobile/features/student/profile/data/models/update_student_profile_request_model.dart";
import "package:draya_mobile/features/student/profile/domain/repos/student_profile_repo.dart";

class UpdateStudentProfileUseCase
    implements
        AppUseCase<ApiResult<StudentProfileModel>,
            UpdateStudentProfileRequestModel> {
  final StudentProfileRepo _studentProfileRepo;

  UpdateStudentProfileUseCase(this._studentProfileRepo);

  @override
  Future<ApiResult<StudentProfileModel>> call({
    UpdateStudentProfileRequestModel? params,
  }) async {
    return await _studentProfileRepo.updateStudentProfile(params!);
  }
}
