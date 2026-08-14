import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart';
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
}
