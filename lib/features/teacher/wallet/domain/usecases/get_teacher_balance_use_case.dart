import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart";

class GetTeacherBalanceUseCase
    implements AppUseCase<ApiResult<BalanceModel>, void> {
  final WalletRepo _walletRepo;

  GetTeacherBalanceUseCase(this._walletRepo);

  @override
  Future<ApiResult<BalanceModel>> call({void params}) async {
    return await _walletRepo.getTeacherBalance();
  }
}
