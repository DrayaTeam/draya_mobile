import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_response_model.dart';
import 'package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart';

class TopUpUseCase
    implements AppUseCase<ApiResult<TopUpResponseModel>, TopUpRequestModel> {
  final WalletRepo _walletRepo;

  TopUpUseCase(this._walletRepo);

  @override
  Future<ApiResult<TopUpResponseModel>> call({
    TopUpRequestModel? params,
  }) async {
    return await _walletRepo.topUp(topUpRequestModel: params!);
  }
}
