import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class CreatePayoutAccountUseCase
    implements
        AppUseCase<ApiResult<PayoutAccountModel>, PayoutAccountRequestModel> {
  final WalletRepo _walletRepo;

  CreatePayoutAccountUseCase(this._walletRepo);

  @override
  Future<ApiResult<PayoutAccountModel>> call({
    PayoutAccountRequestModel? params,
  }) async {
    return await _walletRepo.createPayoutAccount(
      payoutAccountRequestModel: params!,
    );
  }
}
