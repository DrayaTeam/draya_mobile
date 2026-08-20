import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart";
import "package:draya_mobile/features/auth/domain/repos/auth_repo.dart";

class TeacherRegisterUseCase
    implements
        AppUseCase<ApiResult<AuthResponseModel>, RegisterTeacherRequestModel> {
  final AuthRepo authRepo;

  TeacherRegisterUseCase(this.authRepo);
  @override
  Future<ApiResult<AuthResponseModel>> call({
    RegisterTeacherRequestModel? params,
  }) async {
    return await authRepo.registerTeacher(params!);
  }
}
