import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class GetWithdrawalsParams {
  final int pageNumber;
  final int pageSize;

  const GetWithdrawalsParams({
    this.pageNumber = 1,
    this.pageSize = 20,
  });
}

class GetWithdrawalsUseCase
    implements
        AppUseCase<ApiResult<WithdrawalPagedResultModel>, GetWithdrawalsParams> {
  final WalletRepo _walletRepo;

  GetWithdrawalsUseCase(this._walletRepo);

  @override
  Future<ApiResult<WithdrawalPagedResultModel>> call({
    GetWithdrawalsParams? params,
  }) async {
    final effectiveParams = params ?? const GetWithdrawalsParams();
    return await _walletRepo.getWithdrawals(
      pageNumber: effectiveParams.pageNumber,
      pageSize: effectiveParams.pageSize,
    );
  }
}
