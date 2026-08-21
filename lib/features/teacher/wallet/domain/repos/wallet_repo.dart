import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_response_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_request_model.dart";

abstract class WalletRepo {
  Future<ApiResult<BalanceModel>> getTeacherBalance();

  Future<ApiResult<TopUpResponseModel>> topUp({
    required TopUpRequestModel topUpRequestModel,
  });

  Future<ApiResult<void>> confirmPayment({
    required String paymentId,
    bool isSuccess,
  });

  Future<ApiResult<TransactionPagedResultModel>> getTransactions({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<ApiResult<List<PayoutAccountModel>>> getPayoutAccounts();

  Future<ApiResult<PayoutAccountModel>> createPayoutAccount({
    required PayoutAccountRequestModel payoutAccountRequestModel,
  });

  Future<ApiResult<PayoutAccountModel>> updatePayoutAccount({
    required String id,
    required PayoutAccountRequestModel payoutAccountRequestModel,
  });

  Future<ApiResult<void>> deletePayoutAccount({
    required String id,
  });

  Future<ApiResult<WithdrawalPagedResultModel>> getWithdrawals({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<ApiResult<WithdrawalModel>> createWithdrawal({
    required WithdrawalRequestModel withdrawalRequestModel,
  });
}
