import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/domain/repos/auth_repo.dart";

class LoginUseCase
    implements AppUseCase<ApiResult<AuthResponseModel>, LoginRequestModel> {
  final AuthRepo authRepo;

  LoginUseCase(this.authRepo);
  @override
  Future<ApiResult<AuthResponseModel>> call({LoginRequestModel? params}) async {
    return await authRepo.login(params!);
  }
}
