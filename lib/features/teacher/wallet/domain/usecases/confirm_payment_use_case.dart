import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class ConfirmPaymentParams {
  final String paymentId;
  final bool isSuccess;

  const ConfirmPaymentParams({
    required this.paymentId,
    this.isSuccess = true,
  });
}

class ConfirmPaymentUseCase
    implements AppUseCase<ApiResult<void>, ConfirmPaymentParams> {
  final WalletRepo _walletRepo;

  ConfirmPaymentUseCase(this._walletRepo);

  @override
  Future<ApiResult<void>> call({ConfirmPaymentParams? params}) async {
    return await _walletRepo.confirmPayment(
      paymentId: params!.paymentId,
      isSuccess: params.isSuccess,
    );
  }
}
