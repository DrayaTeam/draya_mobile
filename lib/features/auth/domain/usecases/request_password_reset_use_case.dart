import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/request_password_reset_model.dart";
import "package:draya_mobile/features/auth/domain/repos/auth_repo.dart";

class RequestPasswordResetUseCase
    implements AppUseCase<ApiResult<void>, RequestPasswordResetModel> {
  final AuthRepo _authRepo;

  RequestPasswordResetUseCase(this._authRepo);

  @override
  Future<ApiResult<void>> call({RequestPasswordResetModel? params}) async {
    return await _authRepo.requestPasswordReset(
      requestPasswordResetModel: params!,
    );
  }
}
