import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/confirm_password_reset_model.dart";
import "package:draya_mobile/features/auth/domain/repos/auth_repo.dart";

class ConfirmPasswordResetUseCase
    implements AppUseCase<ApiResult<void>, ConfirmPasswordResetModel> {
  final AuthRepo _authRepo;

  ConfirmPasswordResetUseCase(this._authRepo);

  @override
  Future<ApiResult<void>> call({ConfirmPasswordResetModel? params}) async {
    return await _authRepo.confirmPasswordReset(
      confirmPasswordResetModel: params!,
    );
  }
}
