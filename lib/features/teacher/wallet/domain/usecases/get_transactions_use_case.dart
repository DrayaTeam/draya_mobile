import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class GetTransactionsParams {
  final int pageNumber;
  final int pageSize;

  const GetTransactionsParams({
    this.pageNumber = 1,
    this.pageSize = 20,
  });
}

class GetTransactionsUseCase
    implements
        AppUseCase<ApiResult<TransactionPagedResultModel>, GetTransactionsParams> {
  final WalletRepo _walletRepo;

  GetTransactionsUseCase(this._walletRepo);

  @override
  Future<ApiResult<TransactionPagedResultModel>> call({
    GetTransactionsParams? params,
  }) async {
    final effectiveParams = params ?? const GetTransactionsParams();
    return await _walletRepo.getTransactions(
      pageNumber: effectiveParams.pageNumber,
      pageSize: effectiveParams.pageSize,
    );
  }
}
