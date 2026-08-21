import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class GetPayoutAccountsUseCase
    implements AppUseCase<ApiResult<List<PayoutAccountModel>>, void> {
  final WalletRepo _walletRepo;

  GetPayoutAccountsUseCase(this._walletRepo);

  @override
  Future<ApiResult<List<PayoutAccountModel>>> call({void params}) async {
    return await _walletRepo.getPayoutAccounts();
  }
}
