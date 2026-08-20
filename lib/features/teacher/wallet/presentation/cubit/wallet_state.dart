import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "wallet_state.freezed.dart";

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    @Default(CubitStatus.initial) CubitStatus status,
    BalanceModel? teacherBalance,
    ApiErrorModel? apiErrorModel,
  }) = _WalletState;
}
