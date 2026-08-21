import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class DeletePayoutAccountUseCase
    implements AppUseCase<ApiResult<void>, String> {
  final WalletRepo _walletRepo;

  DeletePayoutAccountUseCase(this._walletRepo);

  @override
  Future<ApiResult<void>> call({String? params}) async {
    return await _walletRepo.deletePayoutAccount(id: params!);
  }
}
