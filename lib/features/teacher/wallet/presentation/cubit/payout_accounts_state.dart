import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "payout_accounts_state.freezed.dart";

@freezed
abstract class PayoutAccountsState with _$PayoutAccountsState {
  const factory PayoutAccountsState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<PayoutAccountModel> accounts,
    @Default(false) bool isActionLoading,
    String? actionSuccessMessage,
    ApiErrorModel? apiErrorModel,
  }) = _PayoutAccountsState;
}
