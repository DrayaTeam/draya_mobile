import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_constants.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart';
import 'package:draya_mobile/features/teacher/wallet/data/source/wallet_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part "wallet_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class WalletApiService {
  factory WalletApiService(Dio dio) = _WalletApiService;

  @GET(WalletApiConstants.balance)
  Future<BalanceModel> getTeacherBalance();
}
