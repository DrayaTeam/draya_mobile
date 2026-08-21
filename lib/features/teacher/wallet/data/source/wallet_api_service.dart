import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_response_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/source/wallet_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "wallet_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class WalletApiService {
  factory WalletApiService(Dio dio) = _WalletApiService;

  @GET(WalletApiConstants.balance)
  Future<BalanceModel> getTeacherBalance();

  @POST(WalletApiConstants.topUp)
  Future<TopUpResponseModel> topUp(@Body() TopUpRequestModel topUpRequestModel);

  @POST("${WalletApiConstants.confirmPayment}/{id}")
  Future<void> confirmPayment(
    @Path("id") String id,
    @Query("isSuccess") bool isSuccess,
  );

  @GET(WalletApiConstants.transactions)
  Future<TransactionPagedResultModel> getTransactions({
    @Query("pageNumber") int pageNumber = 1,
    @Query("pageSize") int pageSize = 20,
  });

  @GET(WalletApiConstants.payoutAccounts)
  Future<List<PayoutAccountModel>> getPayoutAccounts();

  @POST(WalletApiConstants.payoutAccounts)
  Future<PayoutAccountModel> createPayoutAccount(
    @Body() PayoutAccountRequestModel payoutAccountRequestModel,
  );

  @PUT("${WalletApiConstants.payoutAccounts}/{id}")
  Future<PayoutAccountModel> updatePayoutAccount(
    @Path("id") String id,
    @Body() PayoutAccountRequestModel payoutAccountRequestModel,
  );

  @DELETE("${WalletApiConstants.payoutAccounts}/{id}")
  Future<void> deletePayoutAccount(@Path("id") String id);

  @GET(WalletApiConstants.withdrawals)
  Future<WithdrawalPagedResultModel> getWithdrawals({
    @Query("pageNumber") int pageNumber = 1,
    @Query("pageSize") int pageSize = 20,
  });

  @POST(WalletApiConstants.withdrawals)
  Future<WithdrawalModel> createWithdrawal(
    @Body() WithdrawalRequestModel withdrawalRequestModel,
  );
}
