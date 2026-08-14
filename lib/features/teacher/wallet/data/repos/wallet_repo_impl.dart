import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_response_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/source/wallet_api_service.dart';
import 'package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletApiService _walletApiService;

  WalletRepoImpl(this._walletApiService);

  @override
  Future<ApiResult<BalanceModel>> getTeacherBalance() async {
    try {
      final response = await _walletApiService.getTeacherBalance();

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<TopUpResponseModel>> topUp({
    required TopUpRequestModel topUpRequestModel,
  }) async {
    try {
      final response = await _walletApiService.topUp(topUpRequestModel);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> confirmPayment({
    required String paymentId,
    bool isSuccess = true,
  }) async {
    try {
      await _walletApiService.confirmPayment(paymentId, isSuccess);

      return const ApiResult<void>.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
