import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart';

abstract class WalletRepo {
  Future<ApiResult<BalanceModel>> getTeacherBalance();
}
