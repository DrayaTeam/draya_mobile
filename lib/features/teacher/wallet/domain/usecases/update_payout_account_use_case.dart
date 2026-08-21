import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class UpdatePayoutAccountParams {
  final String id;
  final PayoutAccountRequestModel requestModel;

  const UpdatePayoutAccountParams({
    required this.id,
    required this.requestModel,
  });
}

class UpdatePayoutAccountUseCase
    implements
        AppUseCase<ApiResult<PayoutAccountModel>, UpdatePayoutAccountParams> {
  final WalletRepo _walletRepo;

  UpdatePayoutAccountUseCase(this._walletRepo);

  @override
  Future<ApiResult<PayoutAccountModel>> call({
    UpdatePayoutAccountParams? params,
  }) async {
    return await _walletRepo.updatePayoutAccount(
      id: params!.id,
      payoutAccountRequestModel: params.requestModel,
    );
  }
}
