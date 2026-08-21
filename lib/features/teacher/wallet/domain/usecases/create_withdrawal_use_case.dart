import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class CreateWithdrawalUseCase
    implements
        AppUseCase<ApiResult<WithdrawalModel>, WithdrawalRequestModel> {
  final WalletRepo _walletRepo;

  CreateWithdrawalUseCase(this._walletRepo);

  @override
  Future<ApiResult<WithdrawalModel>> call({
    WithdrawalRequestModel? params,
  }) async {
    return await _walletRepo.createWithdrawal(
      withdrawalRequestModel: params!,
    );
  }
}
