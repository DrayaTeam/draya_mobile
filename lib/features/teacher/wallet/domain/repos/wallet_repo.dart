import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_response_model.dart';

abstract class WalletRepo {
  Future<ApiResult<BalanceModel>> getTeacherBalance();

  Future<ApiResult<TopUpResponseModel>> topUp({
    required TopUpRequestModel topUpRequestModel,
  });

  Future<ApiResult<void>> confirmPayment({
    required String paymentId,
    bool isSuccess,
  });
}
