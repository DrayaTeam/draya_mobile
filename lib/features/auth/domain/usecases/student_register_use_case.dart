import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/domain/repos/auth_repo.dart";

class StudentRegisterUseCase
    implements
        AppUseCase<ApiResult<AuthResponseModel>, RegisterStudentRequestModel> {
  final AuthRepo authRepo;

  StudentRegisterUseCase(this.authRepo);
  @override
  Future<ApiResult<AuthResponseModel>> call({
    RegisterStudentRequestModel? params,
  }) async {
    return await authRepo.registerStudent(params!);
  }
}
